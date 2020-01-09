//
//  Person+Extensions.swift
//  Directory
//
//  Created by Harold Martin on 1/5/20.
//  Copyright © 2020 Harold Martin. All rights reserved.
//

import Contacts
import CoreData
import Crashlytics
import FirebaseAnalytics
import Foundation
import Kingfisher

private let emojiDepartments = ["Legal": "⚖️", "Business": "💼", "Finance": "💵", "Technology": "📱", "Media": "📸", "Apparel": "🎽"]

extension Person: Identifiable {
    // MARK: - Computed Properties

    var cleanedPhone: String? {
        self.phone?.filter("0123456789.".contains)
    }

    var reportsToNames: String? {
        guard let reportsArray = self.reports?.allObjects as? [Person] else { return nil }
        return reportsArray.compactMap { "\($0.firstName!) \($0.lastName ?? "")" }.joined(separator: ", ")
    }

    var headshotUrl: String? {
        guard let headshots = self.headshot?.allObjects as? [Headshot] else { return nil }
        if headshots.isEmpty { return nil }
        let shot = headshots[0]
        let url = shot.url
        if let thumbs = shot.thumbnails {
            guard let sizes = NSKeyedUnarchiver.unarchiveObject(with: thumbs) as? [String: [String: Any]] else { return url }
            if let large = sizes["large"] {
                return large["url"] as? String ?? url
            }
        }
        return url
    }

    var departmentEmoji: String {
        emojiDepartments[self.department ?? "Unknown", default: "✨"]
    }

    // MARK: - Action Button Functions

    func startCall() {
        if let phone = self.cleanedPhone {
            UIApplication.shared.open(URL(string: "telprompt://" + phone)!)
        }
    }

    func startMessage() {
        if let phone = self.cleanedPhone {
            UIApplication.shared.open(URL(string: "sms://" + phone)!)
        }
    }

    func startEmail() {
        if let email = self.email {
            let outlook = URL(string: "ms-outlook://compose?to=\(email)")!
            if UIApplication.shared.canOpenURL(outlook) {
                UIApplication.shared.open(outlook)
            } else {
                UIApplication.shared.open(URL(string: "mailto://" + email)!)
            }
        }
    }

    func analyticsSelectedParameters(_ type: String) -> [String: String] {
        [
            AnalyticsParameterItemID: "\(type)-\(self.id!)",
            AnalyticsParameterItemName: "\(type)-\(self.firstName!)",
            AnalyticsParameterContentType: type
        ]
    }

    func addToContacts() {
        let contact = buildContact()
        if let url = self.headshotUrl {
            ImageCache.default.retrieveImage(forKey: url) { result in
                switch result {
                case .success(let value):
                    contact.imageData = value.image?.pngData() ?? value.image?.jpegData(compressionQuality: 1.0)
                    self.saveContact(contact)

                case .failure(let error):
                    self.saveContact(contact)
                    Crashlytics.sharedInstance().recordError(error)
                }
            }
        } else {
            saveContact(contact)
        }
    }

    private func buildContact() -> CNMutableContact {
        let contact = CNMutableContact()

        contact.givenName = self.firstName!

        if let lastName = self.lastName {
            contact.familyName = lastName
        }
        if let email = self.email {
            contact.emailAddresses = [CNLabeledValue(label: CNLabelWork, value: NSString(string: email))]
        }
        if let phone = self.phone {
            contact.phoneNumbers = [CNLabeledValue(label: CNLabelPhoneNumberMobile, value: CNPhoneNumber(stringValue: phone))]
        }
        if let title = self.title {
            contact.jobTitle = title
        }

        return contact
    }

    private func saveContact(_ contact: CNMutableContact) {
        let store = CNContactStore()
        let saveRequest = CNSaveRequest()
        saveRequest.add(contact, toContainerWithIdentifier: nil)
        do {
            try store.execute(saveRequest)
            self.addedToContacts = true
            do { try self.managedObjectContext?.save() } catch { Crashlytics.sharedInstance().recordError(error) }
        } catch {
            Crashlytics.sharedInstance().recordError(error)
        }
    }
}
