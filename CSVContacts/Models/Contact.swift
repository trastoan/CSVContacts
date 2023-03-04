//
//  Contact.swift
//  CSVContacts
//
//  Created by Yuri on 04/03/23.
//

import Foundation
import CSVParser

struct Contact: Codable {
    var firstName,
    lastName,
    company,
    address,
    city,
    county,
    state,
    zip,
    email: String
    var phone: [String]

    var nameComponents: PersonNameComponents {
        PersonNameComponents(givenName: self.firstName, familyName: self.lastName)
    }

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case company = "company_name"
        case address, city, county, state, zip, email, phone
    }

    enum AdditionalInfoKeys: String, CodingKey {
        case phone1
    }
}

extension Contact: CSVDecodable {
    init(from line: CSVLine, container: CSVContainer) {
        firstName = container.value(line: line, forKey: CodingKeys.firstName.rawValue) ?? ""
        lastName = container.value(line: line, forKey: CodingKeys.lastName.rawValue) ?? ""
        company = container.value(line: line, forKey: CodingKeys.company.rawValue) ?? ""
        address = container.value(line: line, forKey: CodingKeys.address.rawValue) ?? ""
        city = container.value(line: line, forKey: CodingKeys.city.rawValue) ?? ""
        county = container.value(line: line, forKey: CodingKeys.county.rawValue) ?? ""
        state = container.value(line: line, forKey: CodingKeys.state.rawValue) ?? ""
        zip = container.value(line: line, forKey: CodingKeys.zip.rawValue) ?? ""
        phone = [container.value(line: line, forKey: CodingKeys.phone.rawValue),
                 container.value(line: line, forKey: AdditionalInfoKeys.phone1.rawValue)]
            .compactMap { $0 }
        email = container.value(line: line, forKey: CodingKeys.email.rawValue) ?? ""
    }
}

