//
//  CNLocationViewViewModel.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 7/11/23.
//

import Foundation

protocol CNLocationViewModelDelegate: AnyObject {
    func didFetchInitialLocations()
}

final class CNLocationViewModel {

    weak var delegate: CNLocationViewModelDelegate?

    private var locations: [CNLocation] = [] {
        didSet {
            for location in locations {
                let cellViewModel = CNLocationTableViewCellViewModel(location: location)
                if !cellViewModels.contains(cellViewModel) {
                    cellViewModels.append(cellViewModel)
                }
            }
        }
    }

    // Location response info
    // Will contain NEXT url if present
    private var apiInfo: CNGetAllLocationsResponse.Info?

    public private(set) var cellViewModels: [CNLocationTableViewCellViewModel] = []

    public var shouldShowMoreIndicator: Bool {
        return apiInfo?.next != nil
    }

    public var isLoadingMoreLocations = false

    private var didFinishPagination: (() -> Void)?

    // MARK: - Init

    init() {
        // no-op
    }

    public func registerDidFinishPaginationBlock(_ block: @escaping () -> Void) {
        self.didFinishPagination = block
    }

    public func location(at index: Int) -> CNLocation? {
        guard index < locations.count, index >= 0 else {
            return nil
        }
        return self.locations[index]
    }

    public func fetchLocations() {
        CNService.shared.execute(request: .listLocationsRequest, expecting: CNGetAllLocationsResponse.self) { [weak self] result in
            switch result {
            case .success(let model):
                self?.apiInfo = model.info
                self?.locations = model.results
                DispatchQueue.main.async {
                    self?.delegate?.didFetchInitialLocations()
                }
            case .failure:
                // TODO: Handle error
                break
            }
        }
    }

    private var hasMoreResults: Bool {
        return false
    }

    /// Paginate when additional locations are needed
    public func fetchAdditionalLocations() {
        // Fetch characters
        guard !isLoadingMoreLocations else {
            return
        }

        guard let nextUrlString = apiInfo?.next,
              let url = URL(string: nextUrlString) else {
            return
        }

        isLoadingMoreLocations = true

        guard let request = CNRequest(url: url) else {
            isLoadingMoreLocations = false
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
                strongSelf.apiInfo = resultModel.info

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
