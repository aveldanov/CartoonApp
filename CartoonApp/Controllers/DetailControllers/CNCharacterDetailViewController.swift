//
//  CNCharacterDetailViewController.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 7/1/23.
//

import UIKit

/// Controllet to show about a specific character
final class CNCharacterDetailViewController: UIViewController {

    private let viewModel: CNCharacterDetailViewViewModel
    
    private let characterDetailView: CNCharacterDetailView

    // MARK: - Initilizer

    init(viewModel: CNCharacterDetailViewViewModel) {
        self.viewModel = viewModel
        self.characterDetailView = CNCharacterDetailView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
        setupViewHierarchy()
        setupViewLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func didTapShare() {
        // Share character info
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = viewModel.title
        characterDetailView.collectionView?.delegate = self
        characterDetailView.collectionView?.dataSource = self
    }

    // MARK: - Setup methods

    private func setupViewHierarchy() {
        view.addSubview(characterDetailView)
    }

    private func setupViewLayout() {
        characterDetailView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            characterDetailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            characterDetailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            characterDetailView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            characterDetailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - UICollectionViewDelegate

extension CNCharacterDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        let sectionType = viewModel.sections[section]
        switch sectionType {
        case .photo:
            return 1
        case .information(let viewModels):
            return viewModels.count
        case .episodes(let viewModels):
            return viewModels.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = viewModel.sections[indexPath.section]
        switch sectionType {
        case .photo(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CNCharacterPhotoCollectionViewCell.identifier, for: indexPath) as? CNCharacterPhotoCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: viewModel)
            return cell
        case .information(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CNCharacterInformationCollectionViewCell.identifier, for: indexPath) as? CNCharacterInformationCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: viewModels[indexPath.row])
            return cell
        case .episodes(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CNCharacterEpisodeCollectionViewCell.identifier, for: indexPath) as? CNCharacterEpisodeCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: viewModels[indexPath.row])
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sectionType = viewModel.sections[indexPath.section]
        switch sectionType {
        case .photo, .information:
            break
        case .episodes:
            let episodes = self.viewModel.episodes
            let selection = episodes[indexPath.row]

            let episodeDetailViewController = CNEpisodeDetailViewController(url: URL(string: selection))
            navigationController?.pushViewController(episodeDetailViewController, animated: true)
        }
    }
}
