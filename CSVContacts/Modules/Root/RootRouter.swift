//
//  RootRouter.swift
//  CSVContacts
//
//  Created by Yuri on 04/03/23.
//

import UIKit

protocol RootRouterProtocol {
    static func presentEntryController(in window: UIWindow)
}

class RootRouter {
    static func presentEntryController(in window: UIWindow) {
        window.rootViewController = ContactListRouter.assembleModule()
        window.makeKeyAndVisible()
    }
}
