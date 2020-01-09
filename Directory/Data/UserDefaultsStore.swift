//
//  UserDefaultsStore.swift
//  Directory
//
//  Created by Harold Martin on 1/9/20.
//  Copyright © 2020 Harold Martin. All rights reserved.
//

struct UserDefaultsStore {
    @UserDefault("has_launched_before", defaultValue: false)
    static var hasLaunched: Bool
}
