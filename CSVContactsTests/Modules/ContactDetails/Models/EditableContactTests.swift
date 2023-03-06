//
//  EditableContactTests.swift
//  CSVContactsTests
//
//  Created by Yuri on 06/03/23.
//

import XCTest
@testable import CSVContacts

final class EditableContactTests: XCTestCase {
    func testInitFromContactReturnsCorrectly() {
        let mockedContact = ContactsMock.mocks[0]

        let sut = EditableContact(from: mockedContact)

        XCTAssertEqual(mockedContact.firstName, sut.firstName.value)
        XCTAssertEqual(mockedContact.lastName, sut.lastName.value)
        XCTAssertEqual(mockedContact.company, sut.company.value)
        XCTAssertEqual(mockedContact.address, sut.address.value)
        XCTAssertEqual(mockedContact.city, sut.city.value)
        XCTAssertEqual(mockedContact.county, sut.county.value)
        XCTAssertEqual(mockedContact.state, sut.state.value)
        XCTAssertEqual(mockedContact.zip, sut.zip.value)
        XCTAssertEqual(mockedContact.email, sut.email.value)
        XCTAssertEqual(mockedContact.phone, sut.phone.map { $0.value })
    }

    func testContactFromEditableIsCorrect() {
        let mockedContact = ContactsMock.mocks[0]

        let sut = EditableContact(from: mockedContact)
        let changedName = "Mark"
        sut.firstName.send(changedName)

        let output = sut.contact

        XCTAssertEqual(output.firstName, sut.firstName.value)
        XCTAssertEqual(mockedContact.lastName, sut.lastName.value)
        XCTAssertEqual(output.company, sut.company.value)
        XCTAssertEqual(output.address, sut.address.value)
        XCTAssertEqual(output.city, sut.city.value)
        XCTAssertEqual(output.county, sut.county.value)
        XCTAssertEqual(output.state, sut.state.value)
        XCTAssertEqual(output.zip, sut.zip.value)
        XCTAssertEqual(output.email, sut.email.value)
        XCTAssertEqual(output.phone, sut.phone.map { $0.value })
    }
}
