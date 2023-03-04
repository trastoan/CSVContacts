//
//  ContactListRouter.swift
//  CSVContacts
//
//  Created by Yuri on 04/03/23.
//

import UIKit

protocol ContactListRouterProtocol {
    static func assembleModule() -> UIViewController
    func presentDetailsFor(contact: Contact)
}

final class ContactListRouter: ContactListRouterProtocol {
    static func assembleModule() -> UIViewController {
        return ContactListViewController()
    }

    func presentDetailsFor(contact: Contact) {}
}
