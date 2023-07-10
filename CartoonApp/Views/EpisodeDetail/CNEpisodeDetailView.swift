//
//  CNEpisodeDetailView.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 7/7/23.
//

import UIKit

final class CNEpisodeDetailView: UIView {

    private var viewModel: CNEpisodeDetailViewViewModel?
    private var collectionView: UICollectionView?
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        return spinner
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        let collectionView = createCollectionView()
        self.collectionView = collectionView
        setupViewHierarchy()
        setupViewLayout()
        spinner.startAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods

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

        translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
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
            return self.layout(for: sectionIndex)
        }

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isHidden = true
        collectionView.alpha = 0

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }

    // MARK: - Public methods

    public func configure(with viewModel: CNEpisodeDetailViewViewModel) {
        self.viewModel = viewModel
    }
}

extension CNEpisodeDetailView {
    private func layout(for section: Int) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(100))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: layoutSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}

extension CNEpisodeDetailView: UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .systemYellow
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }



}
