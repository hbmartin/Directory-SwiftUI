//
//  PersonRow.swift
//  Directory
//
//  Created by Harold Martin on 1/8/20.
//  Copyright © 2020 Harold Martin. All rights reserved.
//

import SwiftUI

struct PersonRow: View, Personable {
    var person: Person
    @State var addedToContactsState: Bool  // not to be used directly, simply here to trigger redraw

    var body: some View {
        HStack {
            HeadshotImage(person: person).onTapGesture { self.logSelected("headshot") }
            VStack(alignment: .trailing, spacing: 30) {
                PersonName(person: person).onTapGesture { self.logSelected("name") }
                HStack {
                    Spacer()
                    self.person.phone.map { _ in
                        StartMessageButton(person: person)
                    }
                    Spacer()
                    self.person.phone.map { _ in
                        StartPhoneCallButton(person: person)
                    }
                    Spacer()
                    self.person.email.map { _ in
                        StartEmailButton(person: person)
                    }
                    Spacer()
                    if !self.person.addedToContacts {
                        AddContactButton(person: self.person)
                    }
                }
            }
        }
        .padding(.trailing, 10)
        .frame(minWidth: 128, maxWidth: .infinity, idealHeight: 128)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}
