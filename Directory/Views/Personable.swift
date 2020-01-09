//
//  Personable.swift
//  Directory
//
//  Created by Harold Martin on 1/8/20.
//  Copyright © 2020 Harold Martin. All rights reserved.
//

import Firebase

protocol Personable {
    var person: Person { get }
}

extension Personable {
    func logSelected(_ type: String) {
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: self.person.analyticsSelectedParameters(type))
    }
}
