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
    var contact: Contact

    var editableContact: EditableContact
    var editButtonTitle: String { isEditing ? "Done" : "Edit"}
    var leftButtonTitle: String { isEditing ? "Cancel" : "Close" }

    private (set) var content: [FormSectionComponent] = []
    private var isEditing = false

    init(router: ContactDetailsRouterProtocol = ContactDetailsRouter(),
         contact: Contact) {
        self.router = router
        self.contact = contact
        self.editableContact = EditableContact(from: contact)
        self.content = buildForm()
    }

    func toggleEditMode() {
        if isEditing {
            contact = editableContact.contact
            //Save changes
        }
        isEditing.toggle()
        content = buildForm()
    }

    func cancelAction() {
        if isEditing {
            isEditing.toggle()
            self.editableContact = EditableContact(from: contact)
            content = buildForm()
        } else {
            router.dismiss()
        }
    }

    private func buildForm() -> [FormSectionComponent] {
        var formSections = [FormSectionComponent]()

        let nameSection = FormSectionComponent(items: [
            TextFieldFormComponent(placeholder: "First Name", defaultValue: editableContact.firstName, editable: isEditing),
            TextFieldFormComponent(placeholder: "Last Name", defaultValue: editableContact.lastName, editable: isEditing),
        ])

        let titleNameSection = FormSectionComponent(items: [
            TitleFormComponent(title: contact.nameComponents.formatted())
        ])

        let firstSection = isEditing ? nameSection : titleNameSection

        formSections = [
            firstSection,
            FormSectionComponent(items: [
                TextFieldFormComponent(placeholder: "Address", defaultValue: editableContact.address, editable: isEditing),
                TextFieldFormComponent(placeholder: "County", defaultValue: editableContact.county, editable: isEditing),
                TextFieldFormComponent(placeholder: "City", defaultValue: editableContact.city, editable: isEditing),
                TextFieldFormComponent(placeholder: "State", defaultValue: editableContact.state, editable: isEditing),
                TextFieldFormComponent(placeholder: "Zip", defaultValue: editableContact.zip, editable: isEditing),
            ]),
            FormSectionComponent(items: [
                TextFieldFormComponent(placeholder: "Company", defaultValue: editableContact.company, editable: isEditing),
                TextFieldFormComponent(placeholder: "Email", keyboardType: .emailAddress, defaultValue: editableContact.email, editable: isEditing)
            ]),
        ]

        var phoneSection = [FormComponent]()
        for phone in editableContact.phone {
            phoneSection.append(
                TextFieldFormComponent(placeholder: "Phone", defaultValue: phone, editable: isEditing)
            )
        }
        formSections.insert(FormSectionComponent(items: phoneSection), at: 1)


        return formSections
    }
}
