//
//  ContactDetailsLayout.swift
//  CSVContacts
//
//  Created by Yuri on 04/03/23.
//

import UIKit

final class ContactsDetailsLayout {
    var layout: UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .estimated(44))

        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil,
                                                               top: .fixed(16),
                                                               trailing: nil,
                                                               bottom: .fixed(16))

        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                     heightDimension: .estimated(44))

        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize,
                                                           repeatingSubitem: layoutItem,
                                                           count: 1)
        layoutGroup.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)

        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.contentInsets = .init(top: 20, leading: 0, bottom: 0, trailing: 0)

        return UICollectionViewCompositionalLayout(section: layoutSection)
    }
}
