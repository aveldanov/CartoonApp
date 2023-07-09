//
//  CNCharacterViewController.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 6/11/23.
//

import UIKit

final class CNCharactersViewController: UIViewController {

    private let characterListView = CNCharacterListView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Characters"
        characterListView.delegate = self
        addSearchButton()
        setupViewHierarchy()
        setupViewLayout()
    }

    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }

    @objc
    private func didTapSearch() {
        let searchViewController = CNSearchViewController(config: CNSearchViewController.Config(type: .character))
        searchViewController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(searchViewController, animated: true)
    }

    private func setupViewHierarchy() {
        view.addSubview(characterListView)
    }

    private func setupViewLayout() {

        NSLayoutConstraint.activate([
            characterListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            characterListView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            characterListView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            characterListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - CNCharacterListViewDelegate

extension CNCharactersViewController: CNCharacterListViewDelegate {

    func cnCharacterListView(_ characterListView: CNCharacterListView, didSelectCharacter character: CNCharacter) {
        // Open detail controller for the character
        let viewModel = CNCharacterDetailViewViewModel(character: character)
        let detailViewController = CNCharacterDetailViewController(viewModel: viewModel)
        detailViewController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
