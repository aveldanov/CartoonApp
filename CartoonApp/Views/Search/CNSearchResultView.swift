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
    var collectionViewCellViewModels: [any Hashable] = []


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

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isHidden = true

        collectionView.register(CNCharacterCollectionViewCell.self, forCellWithReuseIdentifier: CNCharacterCollectionViewCell.identifier)

        collectionView.register(CNCharacterEpisodeCollectionViewCell.self, forCellWithReuseIdentifier: CNCharacterEpisodeCollectionViewCell.identifier)

        collectionView.register(CNFooterLoadingCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: CNFooterLoadingCollectionReusableView.identifier)
        return collectionView
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        isHidden = true

        tableView.delegate = self
        tableView.dataSource = self
        collectionView.dataSource = self
        collectionView.delegate = self

        setupViewHierarchy()
        setupViewLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViewHierarchy() {
        addSubviews(tableView, collectionView)
    }

    private func setupViewLayout() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),

            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func processViewModel() {
        guard let viewModel = viewModel else {
            return
        }

        switch viewModel {
        case .characters(let viewModels):
            self.collectionViewCellViewModels = viewModels
            setupCollectionView()
        case .locations(let viewModels):
            setupTableView(viewModels: viewModels)
        case .episodes(let viewModels):
            self.collectionViewCellViewModels = viewModels
            setupCollectionView()
        }
    }

    private func setupCollectionView() {

        self.tableView.isHidden = true
        self.collectionView.isHidden = false

        collectionView.backgroundColor = .red
        collectionView.reloadData()
    }

    private func setupTableView(viewModels: [CNLocationTableViewCellViewModel]) {
        self.locationCellViewModels = viewModels
        tableView.isHidden = false
        collectionView.isHidden = true
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

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension CNSearchResultView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewCellViewModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        // Character | Episode

        let currentViewModel = collectionViewCellViewModels[indexPath.row]
        if let characterViewModel = currentViewModel as? CNCharacterCollectionViewCellViewModel {
            // Character cell
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CNCharacterCollectionViewCell.identifier, for: indexPath) as? CNCharacterCollectionViewCell else {
                fatalError()
            }
            print("VM: ",characterViewModel.characterName)
            cell.configure(with: characterViewModel)
            return cell
        }
        // Episode cell
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CNCharacterEpisodeCollectionViewCell.identifier, for: indexPath) as? CNCharacterEpisodeCollectionViewCell else {
            fatalError()
        }

        if let episodeViewModel = currentViewModel as? CNCharacterEpisodeCollectionViewViewModel {
            cell.configure(with: episodeViewModel)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        // Handle cell tap


    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let currentViewModel = collectionViewCellViewModels[indexPath.row]

        let bounds = collectionView.bounds

        if currentViewModel is CNCharacterCollectionViewCellViewModel {
            // Character size

            let width = (bounds.width - 30) / 2
            let height = width * 1.5
            return CGSize(width: width, height: height)
        }

        // Episode size
        
        return CGSize(width: bounds.width - 20, height: 100)
    }
}
