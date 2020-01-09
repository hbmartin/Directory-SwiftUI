//
//  Dictionary+Extensions.swift
//  Directory
//
//  Created by Harold Martin on 1/9/20.
//  Copyright © 2020 Harold Martin. All rights reserved.
//

extension Dictionary where Key == String, Value == Any {
    func extractAirtableRecords(_ mapping: [String: String]? = nil) throws -> [[String: Any]] {
        guard let casted = self as? [String: [[String: Any]]] else { throw AirtableError.jsonCouldNotCastNested }
        guard var records = casted["records"] else { throw AirtableError.noRecordsFound }
        for (index, record) in records.enumerated() {
            var updated = record
            guard let fields = record["fields"] as? [String: Any] else { continue }
            for (key, value) in fields {
                if let mapped = mapping?[key] {
                    updated[mapped] = value
                } else {
                    updated[key] = value
                }
            }
            updated.removeValue(forKey: "fields")
            records[index] = updated
        }
        return records
    }
}
