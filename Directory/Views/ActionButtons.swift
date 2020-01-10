//
//  ActionButtons.swift
//  Directory
//
//  Created by Harold Martin on 1/8/20.
//  Copyright © 2020 Harold Martin. All rights reserved.
//

import SFSafeSymbols
import SwiftUI

struct AddContactButton: View, Personable {
    var person: Person

    var body: some View {
        Button(action: {
            self.logSelected("add_contact")
            self.person.addToContacts()
        }) {
            Image(systemSymbol: .personCropCircleBadgePlus).defaultFont()
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
            Image(systemSymbol: .messageCircleFill).defaultFont()
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
            Image(systemSymbol: .phoneCircleFill).defaultFont()
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
            Image(systemSymbol: .envelopeCircleFill).defaultFont()
        }
    }
}

private extension View {
    func defaultFont() -> some View {
        self.font(Font.system(size: 30, weight: .thin))
    }
}
