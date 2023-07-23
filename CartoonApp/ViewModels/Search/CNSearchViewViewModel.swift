//
//  CNSearchViewViewModel.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 7/14/23.
//

import Foundation

// Responsibilities
// - show results
// - show no results view
// - kick off
final class CNSearchViewViewModel {

    let config: CNSearchViewController.Config
    private var optionMap: [CNSearchInputViewViewModel.DynamicOption: String] = [:]
    private var optionMapUpdateBlock: (((option: CNSearchInputViewViewModel.DynamicOption, value: String))->Void)?
    private var searchResultHandler: (() -> Void)?

    private var searchText = ""

    // MARK: - Init

    init(config: CNSearchViewController.Config) {
        self.config = config
    }

    // MARK: - Public

    public func registerSearchResultHandler(_ block: @escaping () -> Void) {
        self.searchResultHandler = block
    }

    public func executeSearch() {
        // Create request based on filters
        // https://rickandmortyapi.com/api/character/?name=rick&status=alive

        print(searchText)
        // Build arguments
        var queryParams: [URLQueryItem] = [URLQueryItem(name: "name", value: searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))]

        // Add options
        queryParams.append(contentsOf: optionMap.enumerated().compactMap({ (option, element) in
            let key: CNSearchInputViewViewModel.DynamicOption = element.key
            let value: String = element.value
            return URLQueryItem(name: key.queryArgument, value: value)
        }))

        // Send API call
        // Create request
        let request = CNRequest(endpoint: config.type.endpoint, queryParams: queryParams)

        switch config.type.endpoint {
        case .character:
            return makeSearchApiCall(request: request, type: CNGetAllCharactersResponse.self)
        case .episode:
            return makeSearchApiCall(request: request, type: CNGetAllEpisodesResponse.self)
        case .location:
            return makeSearchApiCall(request: request, type: CNGetAllLocationsResponse.self)
        }
    }


    private func makeSearchApiCall<T: Codable>(request: CNRequest, type: T.Type) {
        CNService.shared.execute(request: request, expecting: type) { [weak self] result in
            // Notify of view results, no results or an error
            switch result {
            case .success(let model):
                self?.processSearchResults(model: model)
            case .failure:
                print("Failed to get results")
                break
            }
        }
    }

    private func processSearchResults(model: Codable) {
        if let characterResults = model as? CNGetAllCharactersResponse {
            let resultsViewModel = CNSearchResultsViewViewModel(results: characterResults.results)
        } else if let episodeResults = model as? CNGetAllEpisodesResponse {
            let resultsViewModel = CNSearchResultsViewViewModel(results: episodeResults.results)
        } else if let locationResults = model as? CNGetAllLocationsResponse {
            let resultsViewModel = CNSearchResultsViewViewModel(results: locationResults.results)
        } else {
            // Error: No results
        }
    }

    public func set(query searchText: String) {
        self.searchText = searchText
    }

    public func set(value: String, for option: CNSearchInputViewViewModel.DynamicOption) {
        optionMap[option] = value
        let tuple = (option, value)
        optionMapUpdateBlock?(tuple)
    }

    public func registerOptionChangeBlock(_ block: @escaping ((option: CNSearchInputViewViewModel.DynamicOption, value: String))->Void) {
        self.optionMapUpdateBlock = block
    }
}
