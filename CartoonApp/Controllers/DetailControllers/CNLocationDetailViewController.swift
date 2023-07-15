//
//  CNLocationDetailViewController.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 7/14/23.
//

import UIKit

/// View Controller to show detail about a single location
final class CNLocationDetailViewController: UIViewController {

    private let viewModel: CNLocationDetailViewViewModel

    private let locationDetailView = CNLocationDetailView()

    init(location: CNLocation) {
        let url = URL(string: location.url)
        self.viewModel = CNLocationDetailViewViewModel(endpointUrl: url)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Location"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))

        setupViewHierarchy()
        setupViewLayout()
        locationDetailView.delegate = self
        viewModel.delegate = self
        viewModel.fetchLocationData()
    }

    @objc
    private func didTapShare() {
        // Share episode info

    }

    private func setupViewHierarchy() {
        view.addSubview(locationDetailView)
    }

    private func setupViewLayout() {
        locationDetailView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            locationDetailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            locationDetailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            locationDetailView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            locationDetailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - Delegates

extension CNLocationDetailViewController: CNLocationDetailViewViewModelDelegate {
    func didFetchLocationDetail() {
        locationDetailView.configure(with: viewModel )
    }
}

extension CNLocationDetailViewController: CNLocationDetailViewDelegate {
    func cnLocationDetailView(_ locationDetailView: CNLocationDetailView, didSelect character: CNCharacter) {
        let viewController = CNCharacterDetailViewController(viewModel: .init(character: character))
        viewController.title = character.name
        viewController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(viewController, animated: true)
    }
}
