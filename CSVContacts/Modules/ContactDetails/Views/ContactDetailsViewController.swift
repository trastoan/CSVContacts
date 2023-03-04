//
//  ContactDetailsViewController.swift
//  CSVContacts
//
//  Created by Yuri on 04/03/23.
//

import UIKit

protocol ContactDetailsView {
    var model: ContactDetailsModel! { get }
}

class ContactDetailsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
