//
//  ContactsMock.swift
//  CSVContactsTests
//
//  Created by Yuri on 06/03/23.
//

import Foundation
@testable import CSVContacts

struct ContactsMock {
    static var mocks: [Contact] {
        [
            Contact(firstName: "James", lastName: "Butt", company: "Benton, John B Jr", address: "6649 N Blue Gum St", city: "New Orleans", county: "Orleans", state: "LA", zip: "70116", email: "jbutt@gmail.com", phone: ["504-845-1427", "504-621-8927"]),
            Contact(firstName: "Carl", lastName: "Doe", company: "Acme Corp", address: "123 Main St", city: "Anytown", county: "Anycounty", state: "CA", zip: "12345", email: "john.doe@example.com", phone: ["555-1234", "555-5678"]
            )
        ]
    }
}
