//
//  ContactListViewController.swift
//  CSVContacts
//
//  Created by Yuri on 04/03/23.
//

import UIKit
import Combine

protocol ContactListView {
    var model: ContactListModel! { get }
}

class ContactListViewController: UIViewController, ContactListView {
    var model: ContactListModel!

    private let contactsTable: UITableView = {
        let table = UITableView(frame: .zero)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(ContactListTableViewCell.self, forCellReuseIdentifier: ContactListTableViewCell.reuseIdentifier)
        return table
    }()

    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Contacts List"
        view.backgroundColor = .systemBackground

        setupTable()
        setupBindings()
        model.loadContacts()
    }

    private func setupBindings() {
        model.hasFinishedFetch
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
            self?.contactsTable.reloadData()
        }.store(in: &cancellables)
    }

    private func setupTable() {
        contactsTable.delegate = self
        contactsTable.dataSource = self
        contactsTable.separatorStyle = .singleLine
        contactsTable.tableFooterView = UIView()

        contactsTable.rowHeight = UITableView.automaticDimension
        contactsTable.estimatedRowHeight = 44

        setupSubviews()
        setupConstraints()
    }

    private func setupSubviews() {
        view.addSubview(contactsTable)
    }

    private func setupConstraints() {
        contactsTable.centerOn(view: view)
    }
}

extension ContactListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return model.numberOfSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.numberOfContacts(for: section)
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return model.titleFor(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ContactListTableViewCell
        cell.setup(model.contact(for: (indexPath.section, indexPath.row)))

        return cell
    }
}

extension ContactListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        model.didSelectContact(at: (indexPath.section, indexPath.row))
    }
}
