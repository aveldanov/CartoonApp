//
//  CNCharacterEpisodeCollectionViewViewModel.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 7/4/23.
//

import Foundation

final class CNCharacterEpisodeCollectionViewViewModel {

    private let episodeDataUrl: URL?
    private var isFetchingEpisode = false
    private var episode: CNEpisode? {
        didSet {
            guard let model = episode else {
                return
            }

        }
    }

    // MARK: - Init

    init(episodeDataUrl: URL?) {
        self.episodeDataUrl = episodeDataUrl
    }

    // MARK: - Public methods

    public func registerForData(_ completion: @escaping () -> Void) {

    }

    public func fetchEpisode() {
        guard !isFetchingEpisode else {
            return
        }
        guard let url = episodeDataUrl, let request = CNRequest(url: url) else {
            return
        }
        isFetchingEpisode = true
        CNService.shared.execute(request, expecting: CNEpisode.self) { [weak self] result in
            switch result {
            case .success(let model):
                self?.episode = model
            case .failure(let failure):
                print(failure)
            }
        }
    }
}
