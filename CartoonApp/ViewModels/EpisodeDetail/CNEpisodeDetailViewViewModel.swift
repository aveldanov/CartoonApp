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
    private var dataTuple: (episode: CNEpisode, characters: [CNCharacter])?{
        didSet {
            createCellViewModels()
            delegate?.didFetchEpisodeDetail()
        }
    }

    public weak var delegate: CNEpisodeDetailViewViewModelDelegate?
    public private(set) var cellViewModels: [SectionType] = []

    enum SectionType {
        case information(viewModels: [CNEpisodeInfoCollectionViewCellViewModel])
        case characters(viewModels: [CNCharacterCollectionViewCellViewModel])
    }

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

    public func character(at index: Int) -> CNCharacter? {
        guard let dataTuple = dataTuple else {
            return nil
        }

        return dataTuple.characters[index]
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
                case .failure:
                    break
                }
            }
        }

        group.notify(queue: .main) {
            self.dataTuple = (episode: episode, characters: characters)
        }
    }

    private func createCellViewModels() {
        guard let dataTuple = dataTuple else {
            return
        }

        let episode = dataTuple.episode
        let characters = dataTuple.characters

        var createdString = ""
        if let date = CNCharacterInformationCollectionViewViewModel.dateFormatter.date(from: episode.created) {
            createdString = CNCharacterInformationCollectionViewViewModel.shortDateFormatter.string(from: date)
        }

        cellViewModels = [
            .information(viewModels: [
                .init(title: "Episode Name: ", value: episode.name),
                .init(title: "Air Date: ", value: episode.air_date),
                .init(title: "Episode: ", value: episode.episode),
                .init(title: "Created On: ", value: createdString),
            ]),
            .characters(viewModels: characters.compactMap({ character in
                return CNCharacterCollectionViewCellViewModel(characterName: character.name, characterStatus: character.status, characterImageURL: URL(string: character.image))
            }))
        ]
    }
}
