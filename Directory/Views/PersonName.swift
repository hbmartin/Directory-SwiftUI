//
//  PersonName.swift
//  Directory
//
//  Created by Harold Martin on 1/8/20.
//  Copyright © 2020 Harold Martin. All rights reserved.
//

import SwiftUI

struct PersonName: View {
    var person: Person

    var body: some View {
        HStack(spacing: 5) {
            Text(person.firstName!).font(.headline).fontWeight(.light)
            Text(person.lastName ?? "").font(.headline)
            Text(" ")
            Text(person.departmentEmoji)
        }
    }
}
