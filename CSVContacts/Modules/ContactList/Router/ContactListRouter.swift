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
    private weak var viewController: UIViewController?

    static func assembleModule() -> UIViewController {
        let router = ContactListRouter()
        let model = ContactListViewModel(router: router)
        let controller = ContactListViewController()

        controller.model = model
        router.viewController = controller

        let nav = UINavigationController(rootViewController: controller)
        return nav
    }

    func presentDetailsFor(contact: Contact) {}
}
