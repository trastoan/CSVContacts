//
//  FormTitleCollectionViewCell.swift
//  CSVContacts
//
//  Created by Yuri on 04/03/23.
//

import UIKit

class FormTitleCollectionViewCell: UICollectionViewCell {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .title1)
        label.textAlignment = .center
        return label
    }()

    override func prepareForReuse() {
        titleLabel.text = ""
    }

    func bind(_ item: FormComponent) {
        guard let titleItem = item as? TitleFormComponent else { return }
        titleLabel.text = titleItem.title
        setupSubviews()
        setupConstraints()
    }

    private func setupSubviews() {
        contentView.addSubview(titleLabel)
    }

    private func setupConstraints() {
        titleLabel.centerOn(view: self.contentView)
    }
}
