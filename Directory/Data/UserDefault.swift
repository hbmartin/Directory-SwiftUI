//
//  UserDefaultWrapper.swift
//  Directory
//
//  Created by Harold Martin on 1/9/20.
//  Copyright © 2020 Harold Martin. All rights reserved.
//

import UIKit

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T

    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
