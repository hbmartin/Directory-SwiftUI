//
//  Fetcher.swift
//  Directory
//
//  Created by Harold Martin on 1/9/20.
//  Copyright © 2020 Harold Martin. All rights reserved.
//

import CoreData
import Crashlytics
import Sync

public struct Fetcher {
    let dataStack: DataStack

    func syncAirtableToCoreData(useLocalFallback: Bool) {
        Airtable.request { result in
            switch result {
            case .success(let records):
                self.sync(records)

            case .failure(let error):
                self.logError(error)
                if useLocalFallback {
                    self.insertFromLocalJSON()
                }
            }
        }
    }

    private func insertFromLocalJSON() {
        Airtable.localFallback("airtable.json") { result in
            switch result {
            case .success(let records):
                self.sync(records, operations: [.insert, .insertRelationships])

            case .failure(let error):
                logError(error)
            }
        }
    }

    private func sync(_ records: [[String: Any]], operations: Sync.OperationOptions = .all) {
        self.dataStack.sync(records, inEntityNamed: Person.entity().name!, operations: operations) { error in
            if let error = error {
                self.logError(error)
            }
        }
    }

    private func logError(_ error: Error) {
        Crashlytics.sharedInstance().recordError(error)
        print(error)
    }
}
