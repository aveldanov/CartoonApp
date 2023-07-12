//
//  CNCharacterCollectionViewCellViewModel.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 6/27/23.
//

import Foundation

final class CNCharacterCollectionViewCellViewModel: Hashable {

    let characterName: String
    let characterStatus: CNCharacterStatus
    let characterImageURL: URL?

    // MARK: - Init

    init(characterName: String, characterStatus: CNCharacterStatus, characterImageURL: URL?) {
        self.characterName = characterName
        self.characterStatus = characterStatus
        self.characterImageURL = characterImageURL
    }

    public var characterStatusText: String {
        return "Status: \(characterStatus.text)"
    }

    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        // TODO Abstract to Image Manager
        guard let url = characterImageURL else {
            completion(.failure(URLError(.badURL)))
            return
        }
        CNImageLoader.shared.downloadImage(url, completion: completion)
    }

    // MARK: - Hashable

    static func == (lhs: CNCharacterCollectionViewCellViewModel, rhs: CNCharacterCollectionViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(characterName)
        hasher.combine(characterStatus)
        hasher.combine(characterImageURL)
    }
}
