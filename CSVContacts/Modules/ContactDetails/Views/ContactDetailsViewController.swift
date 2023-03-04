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

class ContactDetailsViewController: UIViewController, ContactDetailsView {
    var model: ContactDetailsModel!

    private let collectionView: UICollectionView = {
        let collectionLayout = ContactsDetailsLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout.layout)
        collection.backgroundColor = .clear
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(FormTextCollectionViewCell.self, forCellWithReuseIdentifier: FormTextCollectionViewCell.reuseIdentifier)
        collection.register(FormTitleCollectionViewCell.self, forCellWithReuseIdentifier: FormTitleCollectionViewCell.reuseIdentifier)
        return collection
    }()

    private var dataSource: UICollectionViewDiffableDataSource<FormSectionComponent, FormComponent>!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }

    override func loadView() {
        super.loadView()
        setupSubviews()
        setupConstraints()
        setupCollection()
        setupNavigationButtons()
    }

    private func setupCollection() {
        dataSource = makeDataSource()
        collectionView.dataSource = dataSource
        updateDataSource()
    }

    private func setupSubviews() {
        view.addSubview(collectionView)
    }

    private func setupConstraints() {
        collectionView.centerOn(view: view)
    }

    private func setupNavigationButtons() {
        let editButtonTitle = model.editButtonTitle
        let editAction = UIAction { [weak self] _ in
            self?.model.toggleEditMode()
            self?.updateDataSource()
            self?.setupNavigationButtons()
        }
        
        let editButton = UIBarButtonItem(title: editButtonTitle, primaryAction: editAction)
        navigationItem.rightBarButtonItem = editButton

        let leftButtonTitle = model.leftButtonTitle
        let cancelAction = UIAction { [weak self] _ in
            self?.model.cancelAction()
            self?.updateDataSource()
            self?.setupNavigationButtons()
        }
        let cancelButton = UIBarButtonItem(title: leftButtonTitle, primaryAction: cancelAction)
        navigationItem.leftBarButtonItem = cancelButton

    }

    private func makeDataSource() -> UICollectionViewDiffableDataSource<FormSectionComponent, FormComponent> {
        return UICollectionViewDiffableDataSource(collectionView: collectionView) { collection, indexPath, item in

            switch item {
            case is TextFieldFormComponent:
                let cell = collection.dequeueReusableCell(forIndexPath: indexPath) as FormTextCollectionViewCell
                cell.bind(item)

                return cell
            case is TitleFormComponent:
                let cell = collection.dequeueReusableCell(forIndexPath: indexPath) as FormTitleCollectionViewCell
                cell.bind(item)

                return cell
            default:
                fatalError("Invalid component on form")
            }

        }
    }

    private func updateDataSource() {
        DispatchQueue.main.async { [weak self] in
            var snapshot = NSDiffableDataSourceSnapshot<FormSectionComponent, FormComponent>()

            guard let formSections = self?.model.content else { return }
            snapshot.appendSections(formSections)

            formSections.forEach { snapshot.appendItems($0.items, toSection: $0) }

            self?.dataSource.apply(snapshot)
        }
    }
}
