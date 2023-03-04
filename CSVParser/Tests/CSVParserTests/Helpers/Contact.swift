//
//  Contact.swift
//  
//
//  Created by Yuri on 04/03/23.
//

import Foundation
import CSVParser

struct Contact: Codable {
    var name,
        company,
        address,
        phone: String
}

extension Contact: CSVDecodable {
    init(from line: CSVLine, container: CSVContainer) {
        name =  container.value(line: line, forKey: CodingKeys.name.stringValue) ?? ""
        company = container.value(line: line, forKey: CodingKeys.company.stringValue) ?? ""
        address = container.value(line: line, forKey: CodingKeys.address.stringValue) ?? ""
        phone = container.value(line: line, forKey: CodingKeys.phone.stringValue) ?? ""
    }
}
