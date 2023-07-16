//
//  CNSearchInputVIew.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 7/14/23.
//

import UIKit

class CNSearchInputVIew: UIView {

    private let viewModel: CNSearchInputVIewViewModel? {
        didSet {
            guard let viewModel = viewModel, viewModel.hasDynamicOptions else {
                return
            }
            let options = viewModel.options
        }
    }

    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        return searchBar
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemPink

        setupViewHierarchy()
        setupViewLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViewHierarchy() {
        addSubviews(searchBar)
    }

    private func setupViewLayout() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            searchBar.heightAnchor.constraint(equalToConstant: 56)

        ])
    }

    public func configure(with viewModel: CNSearchInputVIewViewModel) {
        searchBar.placeholder = viewModel.searchPlaceholderText
    }
}
