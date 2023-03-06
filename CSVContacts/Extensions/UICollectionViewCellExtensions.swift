//
//  UICollectionViewCellExtensions.swift
//  CSVContacts
//
//  Created by Yuri on 04/03/23.
//

import UIKit
extension UICollectionViewCell: ReusableView {}

extension UICollectionView {
    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath as IndexPath) as? T else {
            fatalError("Could not find cell with identifier: \(T.reuseIdentifier)")
        }

        return cell
    }
}

