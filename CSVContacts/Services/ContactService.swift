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

    init(fileName: String = "sample_contacts", fileExtension: String = "csv") {
        self.contactFileName = fileName
        self.fileExtension = fileExtension
    }

    func getContacts() -> AnyPublisher<[Contact], Error> {
        guard let url = Bundle.main.url(forResource: contactFileName, withExtension: fileExtension) else {
            return Fail(error: ContactServiceErrors.resourceNotFound).eraseToAnyPublisher()
        }
        let parser = CSVParser(url: url)

        guard let contacts = try? parser.decode(type: Contact.self) else {
            return Fail(error: ContactServiceErrors.decodeError).eraseToAnyPublisher()
        }

        return Just(contacts)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
