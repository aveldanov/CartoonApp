//
//  CNLocationView.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 7/11/23.
//

import UIKit

protocol CNLocationViewDelegate: AnyObject {
    func cnLocationView(_ locationView: CNLocationView, didSelect location: CNLocation)
}

final class CNLocationView: UIView {

    public weak var delegate: CNLocationViewDelegate?

    private var viewModel: CNLocationViewViewModel? {
        didSet {
            spinner.stopAnimating()
            tableView.isHidden = false
            tableView.reloadData()
            UIView.animate(withDuration: 0.3) {
                self.tableView.alpha = 1
            }
        }
    }

    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CNLocationTableViewCell.self, forCellReuseIdentifier: CNLocationTableViewCell.identifier)
        table.alpha = 0
        table.isHidden = true
        return table
    }()

    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        return spinner
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        spinner.startAnimating()
        setupViewHierarchy()
        setupViewLayout()
        configureTable()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureTable() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func setupViewHierarchy() {
        addSubviews(tableView, spinner)
    }

    private func setupViewLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        spinner.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),

            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    // MARK: - Private Methods

    public func configure(with viewModel: CNLocationViewViewModel) {
        self.viewModel = viewModel
    }
}

extension CNLocationView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let locationModel = viewModel?.location(at: indexPath.row) else {
            return
        }
        delegate?.cnLocationView(self, didSelect: locationModel)
    }
}

extension CNLocationView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.cellViewModels.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CNLocationTableViewCell.identifier, for: indexPath) as? CNLocationTableViewCell else {
            fatalError()
        }

        guard let cellViewModels = viewModel?.cellViewModels else {
            fatalError()
        }

        let cellViewModel = cellViewModels[indexPath.row]

        cell.configure(with: cellViewModel)
        return cell
    }
}
