//
//  CNEpisodeListViewViewModel.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 7/7/23.
//

import UIKit

protocol CNEpisodeListViewViewModelDelegate: AnyObject {
    func didLoadInitialEpisodes()
    func didLoadMoreEpisodes(with newIndexPaths: [IndexPath])
    func didSelectEpisode(_ episodes: CNEpisode)
}

/// View Model to handle episode list logic
final class CNEpisodeListViewViewModel: NSObject {

    public weak var delegate: CNEpisodeListViewViewModelDelegate?
    private var cellViewModels: [CNCharacterEpisodeCollectionViewViewModel] = []
    private var apiInfo: CNGetAllEpisodesResponse.Info? = nil


    private let borderColor: Set<UIColor> = [
        .systemOrange,
        .systemGreen,
        .systemIndigo,
        .systemTeal,
        .systemYellow,
        .systemRed,
        .systemPink,
        .systemPurple,
        .systemMint
    ]

    private var isLoadingMoreEpisodes = false
    private var episodes: [CNEpisode] = [] {
        didSet {
            for episode in episodes {
                let viewModel = CNCharacterEpisodeCollectionViewViewModel(episodeDataUrl: URL(string: episode.url), borderColor: borderColor.randomElement() ?? .systemBlue)
                if !cellViewModels.contains(viewModel) {
                    cellViewModels.append(viewModel)
                }
            }
        }
    }

    public var shouldShowMoreIndicator: Bool {
        return apiInfo?.next != nil
    }

    /// Fetch initial set of characters
    func fetchEpisodes() {
        CNService.shared.execute(CNRequest.listEpisodesRequest, expecting: CNGetAllEpisodesResponse.self) { [weak self] result in
            switch result {
            case .success(let resultModel):
                self?.episodes = resultModel.results
                self?.apiInfo = resultModel.info
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialEpisodes()
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }

    /// Paginate when additional episodes are needed
    public func fetchAdditionalEpisodes(url: URL) {
        // Fetch characters
        guard !isLoadingMoreEpisodes else {
            return
        }
        print("[CNEpisodeListViewViewModel] Fetch more!!!")
        isLoadingMoreEpisodes = true

        guard let request = CNRequest(url: url) else {
            isLoadingMoreEpisodes = false
            print("[CNEpisodeListViewViewModel] Failed to create request")
            return
        }

        CNService.shared.execute(request, expecting: CNGetAllEpisodesResponse.self) { [weak self] result in
            print("[CNEpisodeListViewViewModel] Fetching more episodes")
            guard let strongSelf = self else {
                return
            }

            switch result {
            case .success(let resultModel):
                let moreResults = resultModel.results
                strongSelf.apiInfo = resultModel.info

                let originalCount = strongSelf.episodes.count
                let newCount = moreResults.count
                let totalCount = originalCount + newCount
                let startingIndex = totalCount - newCount
                let indexPathsToAdd: [IndexPath] = Array(startingIndex..<(startingIndex+newCount)).compactMap({
                    return IndexPath(row: $0, section: 0)
                })
                strongSelf.episodes.append(contentsOf: moreResults)
                DispatchQueue.main.async {
                    strongSelf.delegate?.didLoadMoreEpisodes(with: indexPathsToAdd)
                }
                strongSelf.isLoadingMoreEpisodes = false
            case .failure(let failure):
                print(failure)
                strongSelf.isLoadingMoreEpisodes = false
            }
        }
    }
}

// MARK: - Collection View Methods

extension CNEpisodeListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    // MARK: - UICollectionViewDataSource methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CNCharacterEpisodeCollectionViewCell.identifier, for: indexPath) as? CNCharacterEpisodeCollectionViewCell else {
            fatalError("[CNEpisodeListViewViewModel] Unsupported Cell")
        }

        let viewModel = cellViewModels[indexPath.row]
        cell.configure(with: viewModel)
        return cell
    }

    // MARK: - UICollectionViewDelegateFlowLayout methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = collectionView.bounds.width - 20
        let height = 100.0
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let episode = episodes[indexPath.row]
        delegate?.didSelectEpisode(episode)
    }

    // Footer setup
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        guard kind == UICollectionView.elementKindSectionFooter, let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CNFooterLoadingCollectionReusableView.identifier, for: indexPath) as? CNFooterLoadingCollectionReusableView else {
            fatalError("[CNEpisodeListViewViewModel] could not load footer")
        }
        footer.startAnimating()
        return footer
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard shouldShowMoreIndicator else {
            return .zero
        }
        return CGSize(width: collectionView.frame.width, height: 100)
    }
}

// MARK: - Scroll View

extension CNEpisodeListViewViewModel: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard shouldShowMoreIndicator,
              !isLoadingMoreEpisodes,
              !cellViewModels.isEmpty,
              let nextUrlString = apiInfo?.next,
              let url = URL(string: nextUrlString) else {
            return
        }

        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] timer in
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height

            if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
                self?.fetchAdditionalEpisodes(url: url)
            }
            timer.invalidate()
        }
    }
}

