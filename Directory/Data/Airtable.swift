//
//  Airtable.swift
//  Directory
//
//  Created by Harold Martin on 1/9/20.
//  Copyright © 2020 Harold Martin. All rights reserved.
//

import Alamofire

private let airtableApi = "https://api.airtable.com/v0"
private let airtableTable = "Employee directory".addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
private let airtableFilter = "NOT({First Name} = '')".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
private let fieldMappings = ["First Name": "firstName", "Last Name": "lastName", "Reporting to": "reports_ids", "Headshot": "headshot"]

typealias Handler = (Swift.Result<[[String: Any]], AirtableError>) -> Void

enum Airtable {
    static func request(then handler: @escaping Handler) {
        let headers = ["Authorization": "Bearer \(Secrets.airbaseToken)"]
        let url = "\(airtableApi)/\(Secrets.airbaseApp)/\(airtableTable)?maxRecords=100&filterByFormula=\(airtableFilter)"
        Alamofire.request(url, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let JSON):
                guard let casted = JSON as? [String: Any] else {
                    handler(.failure(.jsonParsingFailed))
                    return
                }
                if let error = casted["error"] {
                    if let message = (error as? [String: String])?["message"] {
                        handler(.failure(.apiFailure(message)))
                    } else {
                        // swiftlint:disable multiline_arguments_brackets
                        handler(.failure(AirtableError.apiFailure(
                            "Unknown API error, status code: \(response.response?.statusCode ?? -1)"
                        )))
                        // swiftlint:enable multiline_arguments_brackets
                    }
                    return
                }
                do {
                    let records = try casted.extractAirtableRecords(fieldMappings)
                    handler(.success(records))
                } catch let error as AirtableError {
                    handler(.failure(error))
                } catch {
                    handler(.failure(.unknown(error)))
                }

            case .failure(let error):
                handler(.failure(.requestFailure(error)))
            }
        }
    }

    static func localFallback(_ fileName: String, then handler: Handler) {
        guard let url = URL(string: fileName) else {
            handler(.failure(.localFilePathError))
            return
        }
        guard let filePath = Bundle.main.path(forResource: url.deletingPathExtension().absoluteString, ofType: url.pathExtension) else {
            handler(.failure(.localFilePathError))
            return
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else {
            handler(.failure(.localFileUnopenable))
            return
        }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            handler(.failure(.jsonParsingFailed))
            return
        }
        do {
            let records = try json.extractAirtableRecords(fieldMappings)
            handler(.success(records))
        } catch let error as AirtableError {
            handler(.failure(error))
        } catch {
            handler(.failure(.unknown(error)))
        }
    }
}

enum AirtableError: Error {
    case jsonParsingFailed
    case jsonCouldNotCastNested
    case noRecordsFound
    case apiFailure(_ message: String)
    case requestFailure(_ error: Error)
    case unknown(_ error: Error)
    case localFilePathError
    case localFileUnopenable
}
