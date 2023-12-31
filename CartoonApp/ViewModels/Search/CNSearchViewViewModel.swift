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
    private var optionMap: [CNSearchInputViewModel.DynamicOption: String] = [:]
    private var optionMapUpdateBlock: (((option: CNSearchInputViewModel.DynamicOption, value: String))->Void)?
    private var searchResultHandler: ((CNSearchResultsViewViewModel) -> Void)?
    private var noSearchResultHandler: (() -> Void)?
    private var searchResultModel: Codable?
    private var searchText = ""

    // MARK: - Init

    init(config: CNSearchViewController.Config) {
        self.config = config
    }

    // MARK: - Public

    public func registerSearchResultHandler(_ block: @escaping (CNSearchResultsViewViewModel) -> Void) {
        self.searchResultHandler = block
    }

    public func registerNoSearchResultHandler(_ block: @escaping () -> Void) {
        self.noSearchResultHandler = block
    }

    public func executeSearch() {
        // Create request based on filters
        // https://rickandmortyapi.com/api/character/?name=rick&status=alive

        print(searchText)

        guard !searchText.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }

        // Build arguments
        var queryParams: [URLQueryItem] = [URLQueryItem(name: "name", value: searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))]

        // Add options
        queryParams.append(contentsOf: optionMap.enumerated().compactMap({ (option, element) in
            let key: CNSearchInputViewModel.DynamicOption = element.key
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
                self?.handleNoResults()
                break
            }
        }
    }

    private func processSearchResults(model: Codable) {
        var resultsViewModel: CNSearchResultType?
        var nextUrl: String?

        if let characterResults = model as? CNGetAllCharactersResponse {
            resultsViewModel = .characters(characterResults.results.compactMap({
                return CNCharacterCollectionViewCellViewModel(characterName: $0.name, characterStatus: $0.status, characterImageURL: URL(string: $0.image))
            }))
            nextUrl = characterResults.info.next
        } else if let episodeResults = model as? CNGetAllEpisodesResponse {
            resultsViewModel = .episodes(episodeResults.results.compactMap({
                return CNCharacterEpisodeCollectionViewViewModel(episodeDataUrl: URL(string: $0.url))
            }))
            nextUrl = episodeResults.info.next
        } else if let locationResults = model as? CNGetAllLocationsResponse {
            resultsViewModel = .locations(locationResults.results.compactMap({
                return CNLocationTableViewCellViewModel(location: $0)

            }))
            nextUrl = locationResults.info.next
        }
        if let results = resultsViewModel {
            self.searchResultModel = model
            let viewModel = CNSearchResultsViewViewModel(results: results, next: nextUrl)
            self.searchResultHandler?(viewModel)
            print(results)
        } else {
            // Fallback error
            handleNoResults()
        }
    }

    private func handleNoResults() {
        noSearchResultHandler?()
    }

    public func set(query searchText: String) {
        self.searchText = searchText
    }

    public func set(value: String, for option: CNSearchInputViewModel.DynamicOption) {
        optionMap[option] = value
        let tuple = (option, value)
        optionMapUpdateBlock?(tuple)
    }

    public func registerOptionChangeBlock(_ block: @escaping ((option: CNSearchInputViewModel.DynamicOption, value: String))->Void) {
        self.optionMapUpdateBlock = block
    }

    public func locationSearchResult(at index: Int) -> CNLocation? {
        guard let searchModel = searchResultModel as? CNGetAllLocationsResponse else {
            return nil
        }
        
        return searchModel.results[index]
    }
}
