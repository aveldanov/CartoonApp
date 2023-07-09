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
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
        self.collectionView = createCollectionView()
        setupViewHierarchy()
        setupViewLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods

    private func setupViewHierarchy() {
        translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupViewLayout() {
        NSLayoutConstraint.activate([
            
        ])
    }

    private func createCollectionView() -> UICollectionView {

    }

    // MARK: - Public methods

    public func configure(with viewModel: CNEpisodeDetailViewViewModel) {
        self.viewModel = viewModel
    }

}
