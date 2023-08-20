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

            viewModel?.registerDidFinishPaginationBlock { [weak self] in
                DispatchQueue.main.async {
                    // Loading indicator is off
                    self?.tableView.tableFooterView = nil

                    // Reload data
                    self?.tableView.reloadData()
                }
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

extension CNLocationView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        guard let viewModel = viewModel,
                !viewModel.cellViewModels.isEmpty,
                viewModel.shouldShowMoreIndicator,
              !viewModel.isLoadingMoreLocations else {
            return
        }

        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] timer in
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height

            if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
                DispatchQueue.main.async {
                    self?.showLoadingInidcator()
                }
                viewModel.fetchAdditionalLocations()
            }
            timer.invalidate()
        }
    }

    private func showLoadingInidcator() {
        let footer = CNTableLoadingFooterView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 100))
        tableView.tableFooterView = footer
    }
}

