//
//  CoreDataLogger.swift
//  Directory
//
//  Created by Harold Martin on 1/9/20.
//  Copyright © 2020 Harold Martin. All rights reserved.
//

import CoreData

public class CoreDataLogger {
    let notificationCenter = NotificationCenter.default

    init(_ context: NSManagedObjectContext) {
        notificationCenter.addObserver(
            self,
            selector: #selector(logChange),
            name: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
            object: context
        )
    }

    deinit {
        stop()
    }

    func stop() {
        notificationCenter.removeObserver(self)
    }

    @objc
    func logChange(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }

        if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject> {
            print("--- INSERTS ---")
            print(inserts)
            print("+++++++++++++++")
        }

        if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject> {
            print("--- UPDATES ---")
            for update in updates {
                print(update.changedValues())
            }
            print("+++++++++++++++")
        }

        if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject> {
            print("--- DELETES ---")
            print(deletes)
            print("+++++++++++++++")
        }
    }
}
