//
//  UserDefaultsStore.swift
//  Directory
//
//  Created by Harold Martin on 1/9/20.
//  Copyright © 2020 Harold Martin. All rights reserved.
//

enum UserDefaultsStore {
    @UserDefault(key: "has_launched_before", defaultValue: false)
    static var hasLaunched: Bool
}
