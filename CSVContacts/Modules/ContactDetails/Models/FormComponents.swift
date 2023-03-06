//
//  TextFormComponent.swift
//  CSVContacts
//
//  Created by Yuri on 04/03/23.
//

import UIKit
import Combine

final class TextFieldFormComponent: FormComponent {
    var subject: CurrentValueSubject<String, Never>

    let placeholder: String
    let editable: Bool
    let keyboardType: UIKeyboardType

    init(placeholder: String, keyboardType: UIKeyboardType = .default, defaultValue: CurrentValueSubject<String, Never>, editable: Bool = false) {
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        self.subject = defaultValue
        self.editable = editable
    }
}

final class TitleFormComponent: FormComponent {
    var title: String

    init(title: String) {
        self.title = title
    }
}
