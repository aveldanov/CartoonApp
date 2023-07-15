//
//  CNLocationViewController.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 6/11/23.
//

import UIKit

final class CNLocationsViewController: UIViewController {

    private let primaryView = CNLocationView()

    private let viewModel = CNLocationViewViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Locations"
        primaryView.delegate = self
        addSearchButton()
        setupViewHierarchy()
        setupViewLayout()
        viewModel.delegate = self
        viewModel.fetchLocations()
    }

    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }

    @objc
    private func didTapSearch() {

    }

    private func setupViewHierarchy() {
        view.addSubviews(primaryView)
    }

    private func setupViewLayout() {
        primaryView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            primaryView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            primaryView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            primaryView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            primaryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - CNLocationViewViewModelDelegate

extension CNLocationsViewController: CNLocationViewViewModelDelegate {
    func didFetchInitialLocations() {
        primaryView.configure(with: viewModel)
    }
}

// MARK: - CNLocationViewDelegate

extension CNLocationsViewController: CNLocationViewDelegate {
    func cnLocationView(_ locationView: CNLocationView, didSelect location: CNLocation) {
        let locationDetailViewController = CNLocationDetailViewController(locaiton: location)
        locationDetailViewController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(locationDetailViewController, animated: true)


        print("YOUYOYOYOYOYOYOY")
    }
}
