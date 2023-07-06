//
//  CNService.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 6/18/23.
//

import Foundation

/// Primary API Service object to get data
final class CNService {
    /// Shared singleton instance
    static let shared = CNService()

    /// Privitized Contructor
    private init() {}

    enum CNServiceError: Error {
        case failedToCreateRequest
        case failedToGetData

    }

    /// Send API call
    /// - Parameters:
    ///   - request: Request Instance
    ///   - completion: Callback with data for error
    public func execute<T: Codable>(_ request: CNRequest,
                                    expecting type: T.Type,
                                    completion: @escaping (Result<T, Error>) -> Void) {
        guard let urlRequest = self.request(from: request) else {
            completion(.failure(CNServiceError.failedToCreateRequest))
            return
        }

        let task = URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            guard let data, error == nil else {
                completion(.failure(error ?? CNServiceError.failedToGetData))
                return
            }
            // Decode response

            do {
                let result = try JSONDecoder().decode(type.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()


    }

    // MARK: - Private Methods

    private func request(from cnRequest: CNRequest) -> URLRequest? {
        guard let url = cnRequest.url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = cnRequest.httpMethod

        return request
    }
}

// Test comment
