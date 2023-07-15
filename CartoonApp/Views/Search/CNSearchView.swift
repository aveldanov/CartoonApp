//
//  CNSearchView.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 7/14/23.
//

import UIKit

final class CNSearchView: UIView {

    private let viewModel: CNSearchViewViewModel?

    // MARK: - Subviews

    // SearchInputView(bar, seleciton buttons)
    // no results view
    // results collection view

    // MARK: - Init

    init(frame: CGRect, viewModel: CNSearchViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        backgroundColor = .red
        setupViewHierarchy()
        setupViewLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViewHierarchy() {

    }

    private func setupViewLayout() {
        translatesAutoresizingMaskIntoConstraints = false
    }
}

// MARK: - Collection View

extension CNSearchView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }


}
