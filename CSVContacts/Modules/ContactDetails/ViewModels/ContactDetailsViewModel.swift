//
//  ContactDetailsViewModel.swift
//  CSVContacts
//
//  Created by Yuri on 04/03/23.
//

import Foundation

protocol ContactDetailsModel {
    var router: ContactDetailsRouterProtocol { get }
    var contact: Contact { get }
    var content: [FormSectionComponent] { get }
    var editButtonTitle: String { get }
    var leftButtonTitle: String { get }

    func toggleEditMode()
    func cancelAction()
}

class ContactDetailsViewModel: ContactDetailsModel {
    let router: ContactDetailsRouterProtocol
    let contact: Contact
    var editButtonTitle: String { isEditing ? "Done" : "Edit"}
    var leftButtonTitle: String { isEditing ? "Cancel" : "Close" }

    private (set) var content: [FormSectionComponent] = []
    private var isEditing = false

    init(router: ContactDetailsRouterProtocol = ContactDetailsRouter(),
         contact: Contact) {
        self.router = router
        self.contact = contact
        content = buildForm()
    }

    func toggleEditMode() {
        isEditing.toggle()
        content = buildForm()
    }

    func cancelAction() {
        if isEditing {
            isEditing.toggle()
        } else {
            router.dismiss()
        }
    }

    private func buildForm() -> [FormSectionComponent] {
        var formSections = [FormSectionComponent]()

        let nameSection = FormSectionComponent(items: [
            TextFieldFormComponent(placeholder: "First Name", defaultValue: contact.firstName, editable: isEditing),
            TextFieldFormComponent(placeholder: "Last Name", defaultValue: contact.lastName, editable: isEditing),
        ])

        let titleNameSection = FormSectionComponent(items: [
            TitleFormComponent(title: contact.nameComponents.formatted())
        ])

        let firstSection = isEditing ? nameSection : titleNameSection

        formSections = [
            firstSection,
            FormSectionComponent(items: [
                TextFieldFormComponent(placeholder: "Address", defaultValue: contact.address, editable: isEditing),
                TextFieldFormComponent(placeholder: "County", defaultValue: contact.county, editable: isEditing),
                TextFieldFormComponent(placeholder: "City", defaultValue: contact.city, editable: isEditing),
                TextFieldFormComponent(placeholder: "State", defaultValue: contact.state, editable: isEditing),
                TextFieldFormComponent(placeholder: "Zip", defaultValue: contact.zip, editable: isEditing),
            ]),
            FormSectionComponent(items: [
                TextFieldFormComponent(placeholder: "Company", defaultValue: contact.company, editable: isEditing),
                TextFieldFormComponent(placeholder: "Email", keyboardType: .emailAddress, defaultValue: contact.email, editable: isEditing)
            ]),
        ]

        var phoneSection = [FormComponent]()
        for phone in contact.phone {
            phoneSection.append(
                TextFieldFormComponent(placeholder: "Phone", defaultValue: phone)
            )
        }
        formSections.insert(FormSectionComponent(items: phoneSection), at: 1)


        return formSections
    }
}
