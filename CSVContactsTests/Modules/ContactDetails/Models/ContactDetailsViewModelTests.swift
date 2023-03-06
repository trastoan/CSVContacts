//
//  ContactDetailsViewModelTests.swift
//  CSVContactsTests
//
//  Created by Yuri on 06/03/23.
//

import XCTest
@testable import CSVContacts

final class ContactDetailsViewModelTests: XCTestCase {
    var sut: ContactDetailsViewModel!
    var routerSpy: ContactDetailsRouterSpy!
    var contact: Contact!
    var mockService: ContactServiceMock!

    override func setUp() {
        routerSpy = ContactDetailsRouterSpy()
        mockService = ContactServiceMock()
        contact = ContactsMock.mocks[0]
        sut = ContactDetailsViewModel(contact: contact, router: routerSpy, contactService: mockService)
    }

    func testFormNumberOfSectionsAreCorrect() {
        XCTAssertEqual(sut.content.count, 4)
        XCTAssertEqual(sut.content[0].items.count, 1)
        sut.toggleEditMode()

        XCTAssertEqual(sut.content[0].items.count, 2)
        sut.toggleEditMode()

        XCTAssertEqual(sut.content[0].items.count, 1)
    }

    func testSectionsWhenNotEditingAreInCorrectOrder() {
        let expected = [
            FormSectionComponent(items: [
                TitleFormComponent(title: contact.nameComponents.formatted())
            ]),
            FormSectionComponent(items: [
                TextFieldFormComponent(placeholder: "Phone", defaultValue: sut.editableContact.phone[0], editable: false),
                TextFieldFormComponent(placeholder: "Phone", defaultValue: sut.editableContact.phone[1], editable: false)
            ]),
            FormSectionComponent(items: [
                TextFieldFormComponent(placeholder: "Address", defaultValue: sut.editableContact.address, editable: false),
                TextFieldFormComponent(placeholder: "County", defaultValue: sut.editableContact.county, editable: false),
                TextFieldFormComponent(placeholder: "City", defaultValue: sut.editableContact.city, editable: false),
                TextFieldFormComponent(placeholder: "State", defaultValue: sut.editableContact.state, editable: false),
                TextFieldFormComponent(placeholder: "Zip", defaultValue: sut.editableContact.zip, editable: false),
            ]),
            FormSectionComponent(items: [
                TextFieldFormComponent(placeholder: "Company", defaultValue: sut.editableContact.company, editable: false),
                TextFieldFormComponent(placeholder: "Email", keyboardType: .emailAddress, defaultValue: sut.editableContact.email, editable: false)
            ])
        ]

        XCTAssertTrue(sectionIsEqual(lhs: sut.content[0], rhs: expected[0]))
        XCTAssertTrue(sectionIsEqual(lhs: sut.content[1], rhs: expected[1]))
        XCTAssertTrue(sectionIsEqual(lhs: sut.content[2], rhs: expected[2]))
        XCTAssertTrue(sectionIsEqual(lhs: sut.content[3], rhs: expected[3]))
    }

    func testSectionsWhenEditingAreInCorrectOrder() {
        let expected = [
            FormSectionComponent(items: [
                TextFieldFormComponent(placeholder: "First Name", defaultValue: sut.editableContact.firstName, editable: true),
                TextFieldFormComponent(placeholder: "Last Name", defaultValue: sut.editableContact.lastName, editable: true),
            ]),
            FormSectionComponent(items: [
                TextFieldFormComponent(placeholder: "Phone", defaultValue: sut.editableContact.phone[0], editable: true),
                TextFieldFormComponent(placeholder: "Phone", defaultValue: sut.editableContact.phone[1], editable: true)
            ]),
            FormSectionComponent(items: [
                TextFieldFormComponent(placeholder: "Address", defaultValue: sut.editableContact.address, editable: true),
                TextFieldFormComponent(placeholder: "County", defaultValue: sut.editableContact.county, editable: true),
                TextFieldFormComponent(placeholder: "City", defaultValue: sut.editableContact.city, editable: true),
                TextFieldFormComponent(placeholder: "State", defaultValue: sut.editableContact.state, editable: true),
                TextFieldFormComponent(placeholder: "Zip", defaultValue: sut.editableContact.zip, editable: true),
            ]),
            FormSectionComponent(items: [
                TextFieldFormComponent(placeholder: "Company", defaultValue: sut.editableContact.company, editable: true),
                TextFieldFormComponent(placeholder: "Email", keyboardType: .emailAddress, defaultValue: sut.editableContact.email, editable: true)
            ])
        ]

        sut.toggleEditMode()

        XCTAssertTrue(sectionIsEqual(lhs: sut.content[0], rhs: expected[0]))
        XCTAssertTrue(sectionIsEqual(lhs: sut.content[1], rhs: expected[1]))
        XCTAssertTrue(sectionIsEqual(lhs: sut.content[2], rhs: expected[2]))
        XCTAssertTrue(sectionIsEqual(lhs: sut.content[3], rhs: expected[3]))
    }

    func testCancelRemovesModifications() {
        sut.toggleEditMode()
        sut.editableContact.firstName.send("Parts")

        XCTAssertEqual(sut.editableContact.firstName.value, "Parts")
        sut.cancelAction()
        XCTAssertEqual(sut.editableContact.firstName.value, contact.firstName)
    }

    func testSavingModificationsPersistChanges() {
        sut.toggleEditMode()
        sut.editableContact.firstName.send("Parts")
        sut.toggleEditMode()

        let expectation = expectation(description: "changes on storage")

        let cancelablle = mockService.getContacts()
            .replaceError(with: [])
            .sink { contacts in
                XCTAssertTrue(contacts.contains(self.sut.contact))
                expectation.fulfill()
            }

        waitForExpectations(timeout: 1)
        cancelablle.cancel()
    }

    func testBarButtonsHaveCorrectText() {
        XCTAssertEqual(sut.editButtonTitle, "Edit")
        XCTAssertNil(sut.leftButtonTitle)
        sut.toggleEditMode()
        XCTAssertEqual(sut.editButtonTitle, "Done")
        XCTAssertEqual(sut.leftButtonTitle, "Cancel")
    }

    private func sectionIsEqual(lhs: FormSectionComponent, rhs: FormSectionComponent) -> Bool {
        for (index, item) in lhs.items.enumerated() {
            if let lhsItem = item as? TextFieldFormComponent, let rhsItem = rhs.items[index] as? TextFieldFormComponent  {
                if !lhsItem.equalTo(rhs: rhsItem) {
                    return false
                }
            } else if let lhsItem = item as? TitleFormComponent, let rhsItem = rhs.items[index] as? TitleFormComponent {
                if !lhsItem.equalTo(rhs: rhsItem) {
                    return false
                }
            } else {
                return false
            }
        }

        return true
    }
}

extension TextFieldFormComponent {
    func equalTo(rhs: TextFieldFormComponent) -> Bool {
        self.placeholder == rhs.placeholder &&
        self.editable == rhs.editable &&
        self.keyboardType == rhs.keyboardType &&
        self.subject.value == rhs.subject.value
    }
}

extension TitleFormComponent {
    func equalTo(rhs: TitleFormComponent) -> Bool {
        self.title == rhs.title
    }
}
