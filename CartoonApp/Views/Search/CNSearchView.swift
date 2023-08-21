//
//  CNSearchView.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 7/14/23.
//

import UIKit

protocol CNSearchViewDelegate: AnyObject {
    func cnSearchView(_ searchView: CNSearchView, didSelectOption option: CNSearchInputViewModel.DynamicOption)
    func cnSearchView(_ searchView: CNSearchView, didSelectLocation location: CNLocation)

}

final class CNSearchView: UIView {

    weak var delegate: CNSearchViewDelegate?

    private let viewModel: CNSearchViewModel

    // MARK: - Subviews

    // No results view
    private let noResultsView = CNNoSearchResultsView()

    // SearchInputView(bar, seleciton buttons)
    private let searchInputView = CNSearchInputView()

    // results collection view

    private let resultsView = CNSearchResultView()

    // MARK: - Init

    init(frame: CGRect, viewModel: CNSearchViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        backgroundColor = .systemBackground
        setupViewHierarchy()
        setupViewLayout()

        searchInputView.configure(with: CNSearchInputViewModel(type: viewModel.config.type))
        searchInputView.delegate = self

        setupHandlers(viewModel: viewModel)

        resultsView.delegate = self
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViewHierarchy() {
        addSubviews(resultsView, noResultsView, searchInputView)
    }

    private func setupViewLayout() {
        searchInputView.translatesAutoresizingMaskIntoConstraints = false
        noResultsView.translatesAutoresizingMaskIntoConstraints = false
        resultsView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // Search Input
            searchInputView.topAnchor.constraint(equalTo: topAnchor),
            searchInputView.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchInputView.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchInputView.heightAnchor.constraint(equalToConstant: viewModel.config.type == .episode ? 62 : 110),

            // Results view
            resultsView.topAnchor.constraint(equalTo: searchInputView.bottomAnchor),
            resultsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            resultsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            resultsView.bottomAnchor.constraint(equalTo: bottomAnchor),

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

    private func setupHandlers(viewModel: CNSearchViewModel) {
        viewModel.registerOptionChangeBlock {tuple in
            // tuple: option | value
            self.searchInputView.update(option: tuple.option, value: tuple.value)
        }

        viewModel.registerSearchResultHandler { [weak self] result in
            DispatchQueue.main.async {
                self?.resultsView.configure(with: result)
                self?.noResultsView.isHidden = true
                self?.resultsView.isHidden = false
            }
        }

        viewModel.registerNoSearchResultHandler { [weak self] in
            DispatchQueue.main.async {
                self?.noResultsView.isHidden = false
                self?.resultsView.isHidden = true
            }
        }
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
    func cnSearchInputView(_ inputView: CNSearchInputView, didSelectOption option: CNSearchInputViewModel.DynamicOption) {
        delegate?.cnSearchView(self, didSelectOption: option)
    }

    func cnSearchInputView(_ inputView: CNSearchInputView, didChangeSearchText text: String) {
        viewModel.set(query: text)
    }

    func cnSearchInputViewDidTapSearchKeyboardButton(_ inputView: CNSearchInputView) {
        viewModel.executeSearch()
    }
}

// MARK: - CNSearchResultViewDelegate

extension CNSearchView: CNSearchResultViewDelegate {
    func cnSearchRestulView(resultView: CNSearchResultView, didTapLocationAt index: Int) {
        print("[CNSearchResultViewDelegate] Yaya \(index)")
        guard let locationModel = viewModel.locationSearchResult(at: index) else {
            return
        }
        
        delegate?.cnSearchView(self, didSelectLocation: locationModel)
    }
}
