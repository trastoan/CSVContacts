//
//  ContactService.swift
//  CSVContacts
//
//  Created by Yuri on 04/03/23.
//

import CSVParser
import Combine
import Foundation

protocol ContactServiceProtocol {
    func getContacts() -> AnyPublisher<[Contact], Error>
    func updateContact(oldContact: Contact, updated: Contact) throws
}

enum ContactServiceErrors: Error {
    case resourceNotFound
    case decodeError
}

struct ContactService: ContactServiceProtocol {
    private let contactFileName: String
    private let fileExtension: String
    private let savedContactsDirectory: URL
    private let bundle: Bundle

    init(fileName: String = "sample_contacts",
         fileExtension: String = "csv",
         directory: URL? = nil,
         bundle: Bundle = Bundle.main) {
        self.contactFileName = fileName
        self.fileExtension = fileExtension
        self.bundle = bundle

        if let directory {
            self.savedContactsDirectory = directory
        } else {
            self.savedContactsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        }
    }

    func getContacts() -> AnyPublisher<[Contact], Error> {
        var contacts = [Contact]()

        if let savedContacts = retrieveEditedContacts() {
            contacts = savedContacts
        } else {
            contacts = retrievePreloadedContacts() ?? []
        }
        
        return Just(contacts)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func updateContact(oldContact: Contact, updated: Contact) throws {
        var contacts = [Contact]()

        if let savedContacts = retrieveEditedContacts() {
            contacts = savedContacts
        } else {
            contacts = retrievePreloadedContacts() ?? []
        }

        contacts.removeAll(where: { $0 == oldContact })
        contacts.append(updated)

        try saveContacts(contacts: contacts)
    }

    private func saveContacts(contacts: [Contact]) throws {
        let data = try JSONEncoder().encode(contacts)
        let url = savedContactsDirectory.appendingPathExtension(contactFileName)

        try data.write(to: url)
    }

    private func retrieveEditedContacts() -> [Contact]? {
        let url = savedContactsDirectory.appendingPathExtension(contactFileName)
        guard let data = try? Data(contentsOf: url) else { return nil }

        return try? JSONDecoder().decode([Contact].self, from: data)
    }

    private func retrievePreloadedContacts() -> [Contact]? {
        guard let url = bundle.url(forResource: contactFileName, withExtension: fileExtension) else {
            return nil
        }

        let parser = CSVParser(url: url, lineBreaker: "\r\n")
        return try? parser.decode(type: Contact.self)
    }
}
