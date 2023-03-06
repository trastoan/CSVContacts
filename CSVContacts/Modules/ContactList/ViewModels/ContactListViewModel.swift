//
//  ContactListViewModel.swift
//  CSVContacts
//
//  Created by Yuri on 04/03/23.
//

import Combine

typealias ContactIndex = (section: Int, row: Int)

protocol ContactListModel {
    var router: ContactListRouterProtocol { get }
    var title: String { get }
    var numberOfSections: Int { get }
    var hasFinishedFetch: PassthroughSubject<Bool, Never> { get }

    func contact(for index: ContactIndex) -> Contact
    func titleFor(section: Int) -> String
    func didSelectContact(at index: ContactIndex)
    func numberOfContacts(for section: Int) -> Int
    func loadContacts()
}

final class ContactListViewModel: ContactListModel {

    var title: String { "Contacts List" }
    var numberOfSections: Int { sections.count }

    var hasFinishedFetch = PassthroughSubject<Bool, Never>()
    private var cancellables = Set<AnyCancellable>()

    var router: ContactListRouterProtocol
    private var contactsService: ContactServiceProtocol

    private var sections: [ContactSection] = []

    init(router: ContactListRouterProtocol,
         contactsService: ContactServiceProtocol = ContactService()) {
        self.router = router
        self.contactsService = contactsService
    }

    func contact(for index: ContactIndex) -> Contact {
        return sections[index.section].contacts[index.row]
    }

    func titleFor(section: Int) -> String {
        return String(sections[section].letter).capitalized
    }

    func didSelectContact(at index: ContactIndex) {
        router.presentDetailsFor(contact: sections[index.section].contacts[index.row])
    }

    func numberOfContacts(for section: Int) -> Int {
        return sections[section].contacts.count
    }

    private func organizeContacts(contacts: [Contact]) {
        sections = []
        for contact in contacts {
            let firstLetter = contact.nameComponents.formatted().first!
            if let contactSection = sections.first(where: {$0.letter == firstLetter }) {
                contactSection.contacts.append(contact)
            } else {
                sections.append(ContactSection(letter: firstLetter, contacts: [contact]))
            }
        }

        sections = sections.sorted(by: \.letter)
    }

    func loadContacts() {
        contactsService.getContacts()
            .replaceError(with: [])
            .sink(receiveValue: { [weak self] in
            self?.organizeContacts(contacts: $0)
            self?.hasFinishedFetch.send(true)
        }).store(in: &cancellables)
    }
}
