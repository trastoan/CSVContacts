//
//  ContactDetailSpies.swift
//  CSVContactsTests
//
//  Created by Yuri on 06/03/23.
//

import UIKit
@testable import CSVContacts

final class ContactDetailsRouterSpy: ContactDetailsRouterProtocol {
    var hasDismissed = false

    static func assembleModule(with contact: CSVContacts.Contact) -> UIViewController {
        UIViewController()
    }

    func dismiss() {
        hasDismissed = true
    }
}
