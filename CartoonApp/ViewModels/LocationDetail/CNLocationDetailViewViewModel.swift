//
//  CNLocationDetailViewViewModel.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 7/14/23.
//

import UIKit


protocol CNLocationDetailViewViewModelDelegate: AnyObject {
    func didFetchLocationDetail()
}

final class CNLocationDetailViewViewModel {

    private let endpointUrl: URL?
    private var dataTuple: (location: CNLocation, characters: [CNCharacter])?{
        didSet {
            createCellViewModels()
            delegate?.didFetchLocationDetail()
        }
    }

    public weak var delegate: CNLocationDetailViewViewModelDelegate?
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

    /// Fetch backing location model
    public func fetchLocationData() {
        guard let url = endpointUrl, let request = CNRequest(url: url) else {
            return
        }

        CNService.shared.execute(request, expecting: CNLocation.self) { [weak self] request in
            switch request {
            case .success(let model):
                self?.fetchRelatedCharacters(location: model)
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

    private func fetchRelatedCharacters(location: CNLocation) {
        let requests: [CNRequest] = location.residents.compactMap({
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
            self.dataTuple = (location: location, characters: characters)
        }
    }

    private func createCellViewModels() {
        guard let dataTuple = dataTuple else {
            return
        }

        let location = dataTuple.location
        let characters = dataTuple.characters

        var createdString = ""
        if let date = CNCharacterInformationCollectionViewViewModel.dateFormatter.date(from: location.created) {
            createdString = CNCharacterInformationCollectionViewViewModel.shortDateFormatter.string(from: date)
        }

        cellViewModels = [
            .information(viewModels: [
                .init(title: "Location Name: ", value: location.name),
                .init(title: "Typa: ", value: location.type),
                .init(title: "Dimension: ", value: location.dimension),
                .init(title: "Created On: ", value: createdString),
            ]),
            .characters(viewModels: characters.compactMap({ character in
                return CNCharacterCollectionViewCellViewModel(characterName: character.name, characterStatus: character.status, characterImageURL: URL(string: character.image))
            }))
        ]
    }
}
