//
//  CNEpisodeDetailViewViewModel.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 7/7/23.
//

import UIKit

protocol CNEpisodeDetailViewViewModelDelegate: AnyObject {
    func didFetchEpisodeDetail()
}

final class CNEpisodeDetailViewViewModel {

    private let endpointUrl: URL?
    private var dataTuple: (CNEpisode, [CNCharacter])?{
        didSet {
            delegate?.didFetchEpisodeDetail()
        }
    }

   public weak var delegate: CNEpisodeDetailViewViewModelDelegate?



    // MARK: - Init

    init(endpointUrl: URL?) {
        self.endpointUrl = endpointUrl
    }


    // MARK: - Public methods

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
    
    // MARK: - Private Methods

    private func fetchRelatedCharacters(episode: CNEpisode) {
        let requests: [CNRequest] = episode.characters.compactMap({
            return URL(string: $0)
        }).compactMap({
            return CNRequest(url: $0)
        })

        // MARK: - Dispatch Group - 10 paraller requests - Notified once all done

        let group = DispatchGroup()
        var characters: [CNCharacter] = []

        for request in requests {
            group.enter() // increment by 1
            CNService.shared.execute(request, expecting: CNCharacter.self) { result in
                defer {
                    group.leave() // decrement by 1, once gets to 0 notifies
                }
                switch result {
                case .success(let model):
                    characters.append(model)
                case .failure(let failure):
                    break
                }
            }
        }

        group.notify(queue: .main) {
            self.dataTuple = (episode, characters)
        }

    }
}
