//
//  ContactDetailsRouter.swift
//  CSVContacts
//
//  Created by Yuri on 04/03/23.
//

import UIKit

protocol ContactDetailsRouterProtocol {
    static func assembleModule(with contact: Contact) -> UIViewController
    func dismiss()
}

class ContactDetailsRouter: ContactDetailsRouterProtocol {
    private weak var viewController: UIViewController?

    static func assembleModule(with contact: Contact) -> UIViewController {
        let router = ContactDetailsRouter()
        let controller = ContactDetailsViewController()
        let model = ContactDetailsViewModel(contact: contact, router: router)

        controller.model = model
        router.viewController = controller

        let nav = UINavigationController(rootViewController: controller)
        return nav
    }

    func dismiss() {
        viewController?.dismiss(animated: true)
    }
}
