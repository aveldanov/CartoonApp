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
        searchText = "Rick"

        // Build arguments
        var queryParams: [URLQueryItem] = [URLQueryItem(name: "name", value: searchText)]

        // Add options
        queryParams.append(contentsOf: optionMap.enumerated().compactMap({ (option, element) in
            let key: CNSearchInputViewViewModel.DynamicOption = element.key
            let value: String = element.value
            return URLQueryItem(name: key.queryArgument, value: value)
        }))

        // Send API call
        // Create request
        let request = CNRequest(endpoint: config.type.endpoint, queryParams: queryParams)

        print(request.url?.absoluteString, queryParams)
        CNService.shared.execute(request, expecting: CNGetAllCharactersResponse.self) { result in
            // Notify of view results, no results or an error
            switch result {
            case .success(let model):
                print(model.results.count)
            case .failure:
                break
            }
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
