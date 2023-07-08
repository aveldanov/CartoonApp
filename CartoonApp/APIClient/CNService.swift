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

    private let cacheManager = CNAPICacheManager()

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

        if let cachedData = cacheManager.getCache(for: request.endpoint, url: request.url) {
            print("[CNService] Using cached API response for \(request.endpoint)")
            do {
                let result = try JSONDecoder().decode(type.self, from: cachedData)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
            return
        }

        guard let urlRequest = self.request(from: request) else {
            completion(.failure(CNServiceError.failedToCreateRequest))
            return
        }

        let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, _, error in
            guard let data, error == nil else {
                completion(.failure(error ?? CNServiceError.failedToGetData))
                return
            }
            // Decode response

            do {
                let result = try JSONDecoder().decode(type.self, from: data)
                self?.cacheManager.setCache(for: request.endpoint, url: request.url, data: data)
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
