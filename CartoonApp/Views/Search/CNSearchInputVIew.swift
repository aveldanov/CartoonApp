//
//  CNSearchInputVIew.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 7/14/23.
//

import UIKit

class CNSearchInputVIew: UIView {

    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"

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

    }
}
