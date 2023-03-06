//
//  FormTextCollectionViewCell.swift
//  CSVContacts
//
//  Created by Yuri on 04/03/23.
//

import UIKit
import Combine

class FormTextCollectionViewCell: UICollectionViewCell {
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .left
        return label
    }()

    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private let textField: UITextField = {
        let txtField = UITextField()
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.layer.cornerRadius = 10
        return txtField
    }()

    private lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [infoLabel, separatorView, textField])
        stack.alignment = .center
        stack.axis = .horizontal
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false

        return stack
    }()

    var formItem: TextFieldFormComponent!
    var cancellables = Set<AnyCancellable>()

    override func prepareForReuse() {
        textField.text = ""
        textField.placeholder = ""
        infoLabel.text = ""
        formItem = nil
        cancellables = []
    }

    func bind(_ item: FormComponent) {
        guard let textItem = item as? TextFieldFormComponent else { return }
        formItem = textItem

        textField.placeholder = formItem.placeholder
        textField.isUserInteractionEnabled = formItem.editable
        textField.keyboardType = formItem.keyboardType

        infoLabel.text = formItem.placeholder
        textField.text = formItem.subject.value

        setupSubviews()
        setupConstraints()
        observeTextField()
    }

    private func observeTextField() {
        NotificationCenter
            .default
            .publisher(for: UITextField.textDidChangeNotification, object: textField)
            .compactMap{ ($0.object as? UITextField)?.text }
            .sink { [weak self] text in
                self?.formItem.subject.send(text)
            }
            .store(in: &cancellables)
    }

    private func setupSubviews() {
        contentView.addSubview(stack)
    }

    private func setupConstraints() {
        stack.centerOn(view: self.contentView)
        infoLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        NSLayoutConstraint.activate([
            separatorView.widthAnchor.constraint(equalToConstant: 1),
            separatorView.heightAnchor.constraint(equalTo: self.stack.heightAnchor, constant: -5),
        ])
    }
}
