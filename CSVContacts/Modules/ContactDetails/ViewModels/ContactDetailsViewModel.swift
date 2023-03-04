//
//  ContactDetailsViewModel.swift
//  CSVContacts
//
//  Created by Yuri on 04/03/23.
//

import Foundation

protocol ContactDetailsModel {
    var router: ContactDetailsRouterProtocol! { get }
    var contact: Contact { get }
}
