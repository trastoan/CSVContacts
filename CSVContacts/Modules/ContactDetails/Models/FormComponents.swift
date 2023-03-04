//
//  TextFormComponent.swift
//  CSVContacts
//
//  Created by Yuri on 04/03/23.
//

import UIKit

final class TextFieldFormComponent: FormComponent {
    let placeholder: String
    let defaultValue: String?
    let editable: Bool
    let keyboardType: UIKeyboardType

    init(placeholder: String, keyboardType: UIKeyboardType = .default, defaultValue: String? = nil, editable: Bool = false) {
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        self.defaultValue = defaultValue
        self.editable = editable
    }
}

final class TitleFormComponent: FormComponent {
    var title: String

    init(title: String) {
        self.title = title
    }
}
