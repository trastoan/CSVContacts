//
//  FormComponentsTests.swift
//  CSVContactsTests
//
//  Created by Yuri on 06/03/23.
//

import XCTest
import Combine
@testable import CSVContacts

final class FormComponentsTests: XCTestCase {
    func testTextFieldCellUpdatesValue() {
        let expected = CurrentValueSubject<String, Never>("")

        let tfComponent = TextFieldFormComponent(placeholder: "City", defaultValue: expected)
        let collectionCell = FormTextCollectionViewCell()

        collectionCell.bind(tfComponent)
        collectionCell.changeTextField(value: "New value")

        let expectation = expectation(description: "Changes expected value")

        let cancellable = expected.sink {
            XCTAssertEqual($0, "New value")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
        cancellable.cancel()
    }
}


extension FormTextCollectionViewCell {

    func changeTextField(value: String) {
        for view in self.contentView.subviews {
            if let stack = view as? UIStackView {
                for arranged in stack.arrangedSubviews {
                    if let tf = arranged as? UITextField {
                        tf.insertText(value)
                    }
                }
            }
        }
    }
}

