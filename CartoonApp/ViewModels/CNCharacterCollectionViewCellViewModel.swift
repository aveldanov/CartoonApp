//
//  CNCharacterCollectionViewCellViewModel.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 6/27/23.
//

import Foundation

final class CNCharacterCollectionViewCellViewModel {

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
        return characterStatus.rawValue
    }

    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        // TODO Abstract to Image Manager
        guard let url = characterImageURL else {
            completion(.failure(URLError(.badURL)))
            return
        }

        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? URLError(.badServerResponse)))
                return
            }

            completion(.success(data))
        }

        task.resume()
    }
}
