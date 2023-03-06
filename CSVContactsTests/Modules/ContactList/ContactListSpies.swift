//
//  ContactListSpies.swift
//  CSVContactsTests
//
//  Created by Yuri on 06/03/23.
//

import Combine
import UIKit
@testable import CSVContacts

final class ContactServiceMock: ContactServiceProtocol {
    var contacts = ContactsMock.mocks

    func getContacts() -> AnyPublisher<[CSVContacts.Contact], Error> {
        return Just(contacts)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func updateContact(oldContact: CSVContacts.Contact, updated: CSVContacts.Contact) throws {
        contacts.removeAll(where: { $0 == oldContact })
        contacts.append(updated)
    }
}

final class ContactListRouterSpy: ContactListRouterProtocol {
    var hasPresentedDetails = false

    static func assembleModule() -> UIViewController {
        UIViewController()
    }

    func presentDetailsFor(contact: CSVContacts.Contact) {
        hasPresentedDetails = true
    }


}
