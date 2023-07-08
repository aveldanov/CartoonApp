//
//  CNRequest.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 6/18/23.
//

import Foundation

/// Object that represents a single API call
final class CNRequest {
    // base url
    // endpoint
    // path component
    // query params
    // https://rickandmortyapi.com/api/character/2

    /// API Constants
    private struct Constants {
        static let baseUrl = "https://rickandmortyapi.com/api"
    }

    /// Desired endpoint
    public let endpoint: CNEndpoint

    /// Path components for API if any
    private let pathComponents: [String]

    /// Arguments for API if any
    private let queryParams: [URLQueryItem]

    /// Constructed url for the API request in String format
    private var urlString: String {
        var string = Constants.baseUrl
        string += "/"
        string += endpoint.rawValue

        if !pathComponents.isEmpty {
            pathComponents.forEach ({
                string += "/\($0)"
            })
        }

        if !queryParams.isEmpty {
            string += "?"
            // name=value&name=value
            let argumentString = queryParams.compactMap({
                guard let value = $0.value else {
                    return nil
                }
                return "\($0.name)=\(value)"
            }).joined(separator: "&")
            string += argumentString
        }

        return string
    }

    /// Computed & constructed API url
    public var url: URL? {
        return URL(string: urlString)
    }

    /// Desired HTTP method
    public let httpMethod = "GET"

    // MARK: - Public methods

    /// Construct request
    /// - Parameters:
    ///   - endpoint: target end poiint
    ///   - pathComponents: collection of path components
    ///   - queryParams: collection of query parameters
    public init(endpoint: CNEndpoint, pathComponents: [String] = [], queryParams: [URLQueryItem] = []) {
        self.endpoint = endpoint
        self.pathComponents = pathComponents
        self.queryParams = queryParams
    }

    /// Attempt to create request
    /// - Parameter url: URL to parse
    convenience init?(url: URL) {
        let string = url.absoluteString
        if !string.contains(Constants.baseUrl) {
            return nil
        }
        let trimmed = string.replacingOccurrences(of: Constants.baseUrl+"/", with: "")
        if trimmed.contains("/") {
            let components = trimmed.components(separatedBy: "/")
//            print(trimmed, components)
            if !components.isEmpty {
                let endpointString = components[0] // Endpoint
                var pathComponents: [String] = []
//                print("components: ", components)
                if components.count > 1 {
                    pathComponents = components
                    // to avoid duplicates components:  ["character", "2"] -> "2"
                    pathComponents.removeFirst()
                }
                if let cnEndpoint = CNEndpoint(rawValue: endpointString) {
//                    print("pathComponents:", pathComponents)
                    self.init(endpoint: cnEndpoint, pathComponents: pathComponents)
                    return
                }
            }
        } else if trimmed.contains("?") {
            let components = trimmed.components(separatedBy: "?")
            if !components.isEmpty, components.count >= 2 {
                let endpointString = components[0]
                let queryItemsString = components[1]
                // value=name&value=name
                let queryItems: [URLQueryItem] = queryItemsString.components(separatedBy: "&").compactMap({
                    guard $0.contains("=") else {
                        return nil
                    }
                    let parts = $0.components(separatedBy:"=")
                    return URLQueryItem(name: parts[0], value: parts[1])
                })
                if let cnEndpoint = CNEndpoint(rawValue: endpointString) {
                    self.init(endpoint: cnEndpoint, queryParams: queryItems)
                    return
                }
            }
        }

        return nil
    }
}


extension CNRequest {
    static let listCharactersRequest = CNRequest(endpoint: .character)
}
