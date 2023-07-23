//
//  CNSearchResultView.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 7/22/23.
//

import UIKit

/// Shows search results UI(table or collection as needed)
final class CNSearchResultView: UIView {

    private var viewModel: CNSearchResultsViewViewModel? {
        didSet {
            self.processViewModel()
        }
    }

    private let tableView: UITableView = {
        let table = UITableView()
        table.register(CNLocationTableViewCell.self, forCellReuseIdentifier: CNLocationTableViewCell.identifier)
        table.isHidden = true
        return table
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        isHidden = true
        setupViewHierarchy()
        setupViewLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViewHierarchy() {
        addSubviews(tableView)
    }


    private func setupViewLayout() {
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        tableView.backgroundColor = .yellow
    }

    private func processViewModel() {
        guard let viewModel = viewModel else {
            return
        }

        switch viewModel {
        case .characters(let viewModels):
            setupCollectionView()
        case .locations(let viewModels):
            setupTableView()
        case .episodes(let viewModels):
            setupCollectionView()

        }
    }

    private func setupCollectionView() {

    }

    private func setupTableView() {
        tableView.isHidden = false
    }

    public func configure(with viewModel: CNSearchResultsViewViewModel) {
        self.viewModel = viewModel
    }
}
