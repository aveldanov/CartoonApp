//
//  CNSearchView.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 7/14/23.
//

import UIKit

protocol CNSearchViewDelegate: AnyObject {
    func cnSearchView(_ searchView: CNSearchView, didSelectOption option: CNSearchInputViewViewModel.DynamicOption)
}

final class CNSearchView: UIView {

    weak var delegate: CNSearchViewDelegate?

    private let viewModel: CNSearchViewViewModel

    // MARK: - Subviews


    // No results view
    private let noResultsView = CNNoSearchResultsView()

    // SearchInputView(bar, seleciton buttons)
    private let searchInputView = CNSearchInputView()

    // results collection view

    // MARK: - Init

    init(frame: CGRect, viewModel: CNSearchViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        backgroundColor = .systemBackground
        setupViewHierarchy()
        setupViewLayout()

        searchInputView.configure(with: CNSearchInputViewViewModel(type: viewModel.config.type))
        searchInputView.delegate = self

   
        viewModel.registerOptionChangeBlock {tuple in
            // tuple: option | value
            print(tuple,"KFJEWHLCH")

            self.searchInputView.update(option: tuple.option, value: tuple.value)
        }
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViewHierarchy() {
        addSubviews(noResultsView, searchInputView)
    }

    private func setupViewLayout() {
        searchInputView.translatesAutoresizingMaskIntoConstraints = false
        noResultsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([

            // Search Input
            searchInputView.topAnchor.constraint(equalTo: topAnchor),
            searchInputView.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchInputView.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchInputView.heightAnchor.constraint(equalToConstant: viewModel.config.type == .episode ? 62 : 110),

            // No Results
            noResultsView.widthAnchor.constraint(equalToConstant: 150),
            noResultsView.heightAnchor.constraint(equalToConstant: 150),
            noResultsView.centerXAnchor.constraint(equalTo: centerXAnchor),
            noResultsView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    public func presentKeyboard() {
        searchInputView.presentKeyboard()
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

// MARK: - CNSearchInputViewDelegate

extension CNSearchView: CNSearchInputViewDelegate {
    func cnSearchInputView(_ inputView: CNSearchInputView, didSelectOption option: CNSearchInputViewViewModel.DynamicOption) {
        delegate?.cnSearchView(self, didSelectOption: option)
    }
}
