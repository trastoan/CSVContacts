//
//  ContactListViewModel.swift
//  CSVContacts
//
//  Created by Yuri on 04/03/23.
//

import Combine

typealias ContactIndex = (section: Int, row: Int)

protocol ContactListModel {
    var router: ContactListRouter { get }
    var title: String { get }
    var numberOfSections: Int { get }
    var hasFinishedFetch: PassthroughSubject<Bool, Never> { get }

    func contact(for index: ContactIndex) -> Contact
    func titleFor(section: Int) -> String
    func didSelectContact(at index: ContactIndex)
    func numberOfContacts(for section: Int) -> Int
    func loadContacts()
}
