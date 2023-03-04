//
//  ContactSection.swift
//  CSVContacts
//
//  Created by Yuri on 04/03/23.
//

import Foundation

class ContactSection: Hashable {
    var letter: Character
    var contacts: [Contact] {
        didSet {
            contacts = contacts.sorted(by: {
                $0.nameComponents.formatted(.name(style: .long)) < $1.nameComponents.formatted(.name(style: .long))
            })
        }
    }

    init(letter: Character, contacts: [Contact] = []) {
        self.letter = letter
        self.contacts = contacts
    }

    static func == (lhs: ContactSection, rhs: ContactSection) -> Bool {
        lhs.letter == rhs.letter
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(letter)
    }
}

