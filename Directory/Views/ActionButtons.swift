//
//  ActionButtons.swift
//  Directory
//
//  Created by Harold Martin on 1/8/20.
//  Copyright © 2020 Harold Martin. All rights reserved.
//

import SwiftUI

struct AddContactButton: View, Personable {
    var person: Person

    var body: some View {
        Button(action: {
            self.logSelected("add_contact")
            self.person.addToContacts()
        }) {
            Image(systemName: "person.crop.circle.badge.plus").font(Font.system(size: 30, weight: .thin))
        }
    }
}

struct StartMessageButton: View, Personable {
    var person: Person

    var body: some View {
        Button(action: {
            self.logSelected("message")
            self.person.startMessage()
        }) {
            Image(systemName: "message.circle.fill").font(Font.system(size: 30, weight: .thin))
        }
    }
}

struct StartPhoneCallButton: View, Personable {
    var person: Person

    var body: some View {
        Button(action: {
            self.logSelected("phone")
            self.person.startCall()
        }) {
            Image(systemName: "phone.circle.fill").font(Font.system(size: 30, weight: .thin))
        }
    }
}

struct StartEmailButton: View, Personable {
    var person: Person

    var body: some View {
        Button(action: {
            self.logSelected("email")
            self.person.startEmail()
        }) {
            Image(systemName: "envelope.circle.fill").font(Font.system(size: 30, weight: .thin))
        }
    }
}
