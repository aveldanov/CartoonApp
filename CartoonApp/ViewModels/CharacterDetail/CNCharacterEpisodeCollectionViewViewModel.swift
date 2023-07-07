//
//  CNCharacterEpisodeCollectionViewViewModel.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 7/4/23.
//

import Foundation

// Using protocol hiding all unnecessary params from the model
protocol CNEpisodeDataRenderProtocol {
    var name: String { get }
    var air_date: String { get }
    var episode: String { get }
}

final class CNCharacterEpisodeCollectionViewViewModel {

    private let episodeDataUrl: URL?
    private var isFetchingEpisode = false
    private var dataCompletion: ((CNEpisodeDataRenderProtocol) -> Void)?

    private var episode: CNEpisode? {
        didSet {
            guard let model = episode else {
                return
            }
            dataCompletion?(model)
        }
    }

    // MARK: - Init

    init(episodeDataUrl: URL?) {
        self.episodeDataUrl = episodeDataUrl
    }

    // MARK: - Public methods

    public func registerForData(_ completion: @escaping (CNEpisodeDataRenderProtocol) -> Void) {
        self.dataCompletion = completion
    }

    public func fetchEpisode() {
        guard !isFetchingEpisode else {
            if let model = episode {
                dataCompletion?(model)
            }
            return
        }
        guard let url = episodeDataUrl, let request = CNRequest(url: url) else {
            return
        }
        isFetchingEpisode = true
        CNService.shared.execute(request, expecting: CNEpisode.self) { [weak self] result in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    self?.episode = model
                }
            case .failure(let failure):
                print(failure)
            }
        }
    }
}
