//
//  CNSearchResultView.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 7/22/23.
//

import UIKit

protocol CNSearchResultViewDelegate: AnyObject {
    func cnSearchRestulView(resultView: CNSearchResultView, didTapLocationAt index: Int)
}

/// Shows search results UI(table or collection as needed)
final class CNSearchResultView: UIView {

    var locationCellViewModels: [CNLocationTableViewCellViewModel] = []

    weak var delegate: CNSearchResultViewDelegate?

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

        tableView.delegate = self
        tableView.dataSource = self

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
    }

    private func processViewModel() {
        guard let viewModel = viewModel else {
            return
        }

        switch viewModel {
        case .characters(let viewModels):
            setupCollectionView()
        case .locations(let viewModels):
            setupTableView(viewModels: viewModels)
        case .episodes(let viewModels):
            setupCollectionView()

        }
    }

    private func setupCollectionView() {

    }

    private func setupTableView(viewModels: [CNLocationTableViewCellViewModel]) {
        self.locationCellViewModels = viewModels
        tableView.isHidden = false
        tableView.reloadData()
    }

    public func configure(with viewModel: CNSearchResultsViewViewModel) {
        self.viewModel = viewModel
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension CNSearchResultView:  UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationCellViewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CNLocationTableViewCell.identifier, for: indexPath) as? CNLocationTableViewCell else {
            fatalError("Failed to dequeue CNLocationTableViewCell")
        }

        let cellViewModel = locationCellViewModels[indexPath.row]
        cell.configure(with: cellViewModel)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.cnSearchRestulView(resultView: self, didTapLocationAt: indexPath.row)
    }
}
