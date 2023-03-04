//
//  ContactListTableViewCell.swift
//  CSVContacts
//
//  Created by Yuri on 04/03/23.
//

import UIKit

class ContactListTableViewCell: UITableViewCell {

    private let contactTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.font(named: "Helvetica", size: 18, weight: .bold)
        return label
    }()

    override func prepareForReuse() {
        super.prepareForReuse()
        self.contactTitleLabel.text = ""
    }

    func setup(_ contact: Contact) {
        self.selectionStyle = .none
        self.accessoryType = .disclosureIndicator
        contactTitleLabel.text = contact.nameComponents.formatted(.name(style: .long))
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("No interface builder is used")
    }

    private func setupSubviews() {
        contentView.addSubview(contactTitleLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            contactTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            contactTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            contactTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            contactTitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }
}
