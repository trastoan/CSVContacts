//
//  EditableContact.swift
//  CSVContacts
//
//  Created by Yuri on 05/03/23.
//

import Combine

final class EditableContact {
    var firstName: CurrentValueSubject<String, Never>
    var lastName: CurrentValueSubject<String, Never>
    var company: CurrentValueSubject<String, Never>
    var address: CurrentValueSubject<String, Never>
    var city: CurrentValueSubject<String, Never>
    var county: CurrentValueSubject<String, Never>
    var state: CurrentValueSubject<String, Never>
    var zip: CurrentValueSubject<String, Never>
    var email: CurrentValueSubject<String, Never>
    var phone: [CurrentValueSubject<String, Never>]

    var contact: Contact {
        Contact(firstName: firstName.value,
                lastName: lastName.value,
                company: company.value,
                address: address.value,
                city: city.value,
                county: county.value,
                state: state.value,
                zip: zip.value,
                email: email.value,
                phone: phone.map { $0.value })
    }

    init(from contact: Contact) {
        self.firstName = CurrentValueSubject<String, Never>(contact.firstName)
        self.lastName = CurrentValueSubject<String, Never>(contact.lastName)
        self.company = CurrentValueSubject<String, Never>(contact.company)
        self.address = CurrentValueSubject<String, Never>(contact.address)
        self.city = CurrentValueSubject<String, Never>(contact.city)
        self.county = CurrentValueSubject<String, Never>(contact.county)
        self.state = CurrentValueSubject<String, Never>(contact.state)
        self.zip = CurrentValueSubject<String, Never>(contact.zip)
        self.email = CurrentValueSubject<String, Never>(contact.email)
        self.phone = contact.phone.map { CurrentValueSubject<String, Never>($0) }
    }
}
