//
//  ContactListViewModelTests.swift
//  CSVContactsTests
//
//  Created by Yuri on 06/03/23.
//

import XCTest
@testable import CSVContacts

final class ContactListViewModelTests: XCTestCase {
    private var sut: ContactListViewModel!
    private var spyRouter: ContactListRouterSpy!
    private var mockService: ContactServiceMock!


    override func setUp() {
        spyRouter = ContactListRouterSpy()
        mockService = ContactServiceMock()
        sut = ContactListViewModel(router: spyRouter, contactsService: mockService)
    }

    override func tearDown() {
        spyRouter = nil
        mockService = nil
        sut = nil
    }

    func testLoadContactSuccess() {
        let expectation = expectation(description: "Loading contacts")

        let cancellable = sut.hasFinishedFetch.sink { _ in
            XCTAssertEqual(self.sut.numberOfSections, 2)
            XCTAssertEqual(self.sut.numberOfContacts(for: 0), 1)
            XCTAssertEqual(self.sut.numberOfContacts(for: 1), 1)
            expectation.fulfill()
        }

        sut.loadContacts()

        waitForExpectations(timeout: 1)
        cancellable.cancel()
    }

    func testPresentDetailsForContact() {
        let expectation = expectation(description: "Details for contact")

        let cancellable = sut.hasFinishedFetch.sink { _ in
            self.sut.didSelectContact(at: (0,0))
            XCTAssertTrue(self.spyRouter.hasPresentedDetails)
            expectation.fulfill()
        }

        sut.loadContacts()

        waitForExpectations(timeout: 1)
        cancellable.cancel()
    }

    func testContactsOrganization() {
        let expectation = expectation(description: "Details for contact")

        let expectedContactOne = ContactsMock.mocks[1]
        let expectedContactTwo = ContactsMock.mocks[0]

        let expectedFirstLetter = String(expectedContactOne.nameComponents.formatted().first!).capitalized
        let expectedSecondLetter = String(expectedContactTwo.nameComponents.formatted().first!).capitalized

        let cancellable = sut.hasFinishedFetch.sink { _ in
            if expectedFirstLetter < expectedSecondLetter {
                XCTAssertEqual(self.sut.titleFor(section: 0), expectedFirstLetter)
                XCTAssertEqual(self.sut.titleFor(section: 1), expectedSecondLetter)

                XCTAssertEqual(self.sut.contact(for: (0,0)), expectedContactOne)
                XCTAssertEqual(self.sut.contact(for: (1,0)), expectedContactTwo)
            } else {
                XCTAssertEqual(self.sut.titleFor(section: 0), expectedSecondLetter)
                XCTAssertEqual(self.sut.titleFor(section: 1), expectedFirstLetter)

                XCTAssertEqual(self.sut.contact(for: (0,0)), expectedContactTwo)
                XCTAssertEqual(self.sut.contact(for: (1,0)), expectedContactOne)
            }

            expectation.fulfill()
        }

        sut.loadContacts()

        waitForExpectations(timeout: 1)
        cancellable.cancel()
    }
}
