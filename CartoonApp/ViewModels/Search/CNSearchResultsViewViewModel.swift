//
//  CNSearchResultsViewViewModel.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 7/22/23.
//

import Foundation

final class CNSearchResultsViewViewModel {

    public private(set) var results: CNSearchResultType
    private var next: String?

    init(results: CNSearchResultType, next: String?) {
        self.results = results
        self.next = next
    }

    public private(set) var isLoadingMoreResults: Bool = false

    public var shouldShowMoreIndicator: Bool {
        return next != nil
    }


    public func fetchAdditionalLocations(completion: @escaping () -> Void) {
        // Fetch characters
        guard !isLoadingMoreResults else {
            return
        }

        guard let nextUrlString = next,
              let url = URL(string: nextUrlString) else {
            return
        }

        isLoadingMoreResults = true

        guard let request = CNRequest(url: url) else {
            isLoadingMoreResults = false
            print("[CNEpisodeListViewViewModel] Failed to create request")
            return
        }

        CNService.shared.execute(request: request, expecting: CNGetAllLocationsResponse.self) { [weak self] result in
            guard let strongSelf = self else {
                return
            }

            switch result {
            case .success(let resultModel):
                let moreResults = resultModel.results
                strongSelf.next = resultModel.info.next // Capture new pagination url if exists

                let additionalLocations = moreResults.compactMap({
                    return CNLocationTableViewCellViewModel(location: $0)
                })

                switch strongSelf.results {
                case .locations(let existingResults):
                    let newResults = existingResults + additionalLocations
                    strongSelf.results = .locations(newResults)
                case .characters, .episodes:
                    break
                }
                
                DispatchQueue.main.async {
                    strongSelf.isLoadingMoreResults = false
                    completion()
                }

            case .failure(let failure):
                print(failure)
                strongSelf.isLoadingMoreResults = false
            }
        }
    }
}
