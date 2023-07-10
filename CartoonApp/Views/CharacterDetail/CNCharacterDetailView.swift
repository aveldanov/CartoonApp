//
//  CNCharacterDetailView.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 7/1/23.
//

import UIKit

/// View for single character info
final class CNCharacterDetailView: UIView {

    public var collectionView: UICollectionView?

    private let viewModel: CNCharacterDetailViewViewModel

    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        return spinner
    }()

    // MARK: - Initilizer

    init(frame: CGRect, viewModel: CNCharacterDetailViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        backgroundColor = .systemBlue

        let collectionView = createCollectionView()
        self.collectionView = collectionView

        setupViewHierarchy()
        setupViewLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViewHierarchy() {
        guard let collectionView = self.collectionView else {
            return
        }
        addSubviews(collectionView, spinner)
    }

    private func setupViewLayout() {
        guard let collectionView = self.collectionView else {
            return
        }

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        translatesAutoresizingMaskIntoConstraints = false
        spinner.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),

            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    private func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            return self.createSectionFor(for: sectionIndex)
        }

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(CNCharacterPhotoCollectionViewCell.self, forCellWithReuseIdentifier: CNCharacterPhotoCollectionViewCell.identifier)
        collectionView.register(CNCharacterInformationCollectionViewCell.self, forCellWithReuseIdentifier: CNCharacterInformationCollectionViewCell.identifier)
        collectionView.register(CNCharacterEpisodeCollectionViewCell.self, forCellWithReuseIdentifier: CNCharacterEpisodeCollectionViewCell.identifier)

        return collectionView
    }

    private func createSectionFor(for sectionIndex: Int) -> NSCollectionLayoutSection {
        let sectionTypes = viewModel.sections

        switch sectionTypes[sectionIndex] {
        case .photo:
            return viewModel.createPhotoSectionLayout()
        case .information:
            return viewModel.createInformationSectionLayout()
        case .episodes:
            return viewModel.createEpisodeSectionLayout()
        }
    }
}
