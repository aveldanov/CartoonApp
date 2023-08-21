//
//  CNSearchResultsViewViewModel.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 7/22/23.
//

import Foundation

final class CNSearchResultsViewModel {
    let results: CNSearchResultType
    let next: String?

    init(results: CNSearchResultType, next: String?) {
        self.results = results
        self.next = next
    }

    public private(set) var isLoadingMoreResults: Bool = false

    public var shouldShowMoreIndicator: Bool {
        return next != nil
    }


    public func fetchAdditionalLocations() {
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
                strongSelf.next = resultModel.info.next // Capture new url if exists

                print("MORE LOCATIONS", strongSelf.apiInfo?.next)

                strongSelf.cellViewModels.append(contentsOf: moreResults.compactMap({
                    return CNLocationTableViewCellViewModel(location: $0)
                }))

                DispatchQueue.main.async {
                    strongSelf.isLoadingMoreLocations = false

                    // Notify via callback
                    strongSelf.didFinishPagination?()
                }

            case .failure(let failure):
                print(failure)
                strongSelf.isLoadingMoreLocations = false
            }
        }
    }
}

enum CNSearchResultType {
    case characters([CNCharacterCollectionViewCellViewModel])
    case episodes([CNCharacterEpisodeCollectionViewViewModel])
    case locations([CNLocationTableViewCellViewModel])
}
