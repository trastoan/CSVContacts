//
//  FormModel.swift
//  CSVContacts
//
//  Created by Yuri on 04/03/23.
//

import Foundation

protocol FormItem {
    var id: UUID { get }
}

protocol FormSectionItem {
    var id: UUID { get }
    var item: [FormComponent] { get }

    init(items: [FormComponent])
}

final class FormSectionComponent: Hashable {

    var id: UUID
    var items: [FormComponent]

    init(items: [FormComponent], id: UUID = UUID()) {
        self.id = id
        self.items = items
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: FormSectionComponent, rhs: FormSectionComponent) -> Bool {
        lhs.id == rhs.id
    }
}

class FormComponent: FormItem, Hashable {
    var id: UUID = UUID()

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: FormComponent, rhs: FormComponent) -> Bool {
        lhs.id == rhs.id
    }
}
