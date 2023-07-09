//
//  CNEpisodeDetailViewViewModel.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 7/7/23.
//

import UIKit

class CNEpisodeDetailViewViewModel {

    private let endpointUrl: URL?

    // MARK: - Init

    init(endpointUrl: URL?) {
        self.endpointUrl = endpointUrl
        fetchEpisodeData()
    }

    /// Fetch backing episode model
    public func fetchEpisodeData() {
        guard let url = endpointUrl, let request = CNRequest(url: url) else {
            return
        }

        CNService.shared.execute(request, expecting: CNEpisode.self) { [weak self] request in
            switch request {
            case .success(let model):
                self?.fetchRelatedCharacters(episode: model)
            case .failure(let failure):
                print(failure)
            }
        }
    }

    private func fetchRelatedCharacters(episode: CNEpisode) {
        let characterURLs: [CNRequest] = episode.characters.compactMap({
            return URL(string: $0)
        }).compactMap({
            return CNRequest(url: $0)
        })

    }
}
