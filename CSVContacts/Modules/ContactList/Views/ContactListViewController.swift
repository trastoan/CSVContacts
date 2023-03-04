//
//  ContactListViewController.swift
//  CSVContacts
//
//  Created by Yuri on 04/03/23.
//

import UIKit

protocol ContactListView {
    var model: ContactListModel! { get }
}

class ContactListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
