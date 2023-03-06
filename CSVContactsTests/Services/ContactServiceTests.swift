//
//  ContactServiceTests.swift
//  CSVContactsTests
//
//  Created by Yuri on 06/03/23.
//

import XCTest
import Combine
@testable import CSVContacts

final class ContactServiceTests: XCTestCase {
    private var sut: ContactService!
    private var cancellables: Set<AnyCancellable>!
    private let tempDirectory = FileManager.default.urls(for: .developerDirectory, in: .userDomainMask)[0]

    override func setUp() {
        let bundle = Bundle(for: ContactServiceTests.self)
        sut = ContactService(fileName: "sample", directory: tempDirectory, bundle: bundle)
        cancellables = Set<AnyCancellable>()
    }

    override func tearDown() {
        sut = nil
        cancellables = nil
        let resourceURL = tempDirectory.appendingPathExtension("sample")
        try? FileManager.default.removeItem(at: resourceURL)
    }


    func testSuccessRetrievingPreloadedContent() {
        let expectation = expectation(description: "load contacts")

        let cancellable = sut.getContacts()
            .replaceError(with: [])
            .sink { contacts in
                XCTAssertFalse(contacts.isEmpty)

                let firstContact = contacts[0]
                XCTAssertEqual(firstContact.firstName, "James")
                XCTAssertEqual(firstContact.lastName, "Butt")
                XCTAssertEqual(firstContact.company, "Benton, John B Jr")
                XCTAssertEqual(firstContact.address, "6649 N Blue Gum St")
                XCTAssertEqual(firstContact.city, "New Orleans")
                XCTAssertEqual(firstContact.county, "Orleans")
                XCTAssertEqual(firstContact.state, "LA")
                XCTAssertEqual(firstContact.zip, "70116")
                XCTAssertEqual(firstContact.email, "jbutt@gmail.com")
                XCTAssertEqual(firstContact.phone, ["504-845-1427", "504-621-8927"])

                expectation.fulfill()
            }

        waitForExpectations(timeout: 1)
        cancellable.cancel()
    }

    func testSuccessUpdatingContact() throws {
        let expectation = expectation(description: "updating contacts")

        let oldContact = Contact(firstName: "James", lastName: "Butt", company: "Benton, John B Jr", address: "6649 N Blue Gum St", city: "New Orleans", county: "Orleans", state: "LA", zip: "70116", email: "jbutt@gmail.com", phone: ["504-845-1427", "504-621-8927"])
        let updatedContact = Contact(firstName: "Updated James", lastName: "Butt", company: "Benton, John B Jr", address: "6649 N Blue Gum St", city: "New Orleans", county: "Orleans", state: "LA", zip: "70116", email: "jbutt@gmail.com", phone: ["504-845-1427", "504-621-8927"])

        try sut.updateContact(oldContact: oldContact, updated: updatedContact)

        let cancellable = sut.getContacts()
            .replaceError(with: [])
            .sink { contacts in
                XCTAssertFalse(contacts.contains(oldContact))
                XCTAssertTrue(contacts.contains(updatedContact))
                expectation.fulfill()
            }

        waitForExpectations(timeout: 1)
        cancellable.cancel()
    }
}
