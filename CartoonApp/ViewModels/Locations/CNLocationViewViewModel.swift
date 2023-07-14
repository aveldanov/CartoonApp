//
//  CNLocationViewViewModel.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 7/11/23.
//

import Foundation

protocol CNLocationViewViewModelDelegate: AnyObject {
    func didFetchInitialLocations()
}

final class CNLocationViewViewModel {

    weak var delegate: CNLocationViewViewModelDelegate?

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

    init() {
        
    }

    public func fetchLocations() {
        CNService.shared.execute(.listLocationsRequest, expecting: CNGetAllLocationsResponse.self) { [weak self] result in
            switch result {
            case .success(let model):
                self?.apiInfo = model.info
                self?.locations = model.results
                DispatchQueue.main.async {
                    self?.delegate?.didFetchInitialLocations()
                }
            case .failure(let error):
                break
            }
        }
        let request = CNRequest(endpoint: .location)
    }

    private var hasMoreResults: Bool {
        return false
    }
}