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
}

enum ContactServiceErrors: Error {
    case resourceNotFound
    case decodeError
}

struct ContactService: ContactServiceProtocol {
    private let contactFileName: String
    private let fileExtension: String
    private let savedContactsDirectory: URL

    init(fileName: String = "sample_contacts", fileExtension: String = "csv", directory: URL? = nil) {
        self.contactFileName = fileName
        self.fileExtension = fileExtension

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

    private func retrieveEditedContacts() -> [Contact]? {
        let url = savedContactsDirectory.appendingPathExtension(contactFileName)
        guard let data = try? Data(contentsOf: url) else { return nil }

        return try? JSONDecoder().decode([Contact].self, from: data)
    }

    private func retrievePreloadedContacts() -> [Contact]? {
        guard let url = Bundle.main.url(forResource: contactFileName, withExtension: fileExtension) else {
            return nil
        }

        let parser = CSVParser(url: url, lineBreaker: "\r\n")
        return try? parser.decode(type: Contact.self)
    }
}
