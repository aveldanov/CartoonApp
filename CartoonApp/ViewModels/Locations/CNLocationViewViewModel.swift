//
//  CNLocationViewViewModel.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 7/11/23.
//

import Foundation

final class CNLocationViewViewModel {

    private var locations: [CNLocation] = []

    // Location response info
    // Will contain NEXT url if present

    private var cellViewModels: [String] = []

    init() {
        
    }

    public func fetchLocations() {
        CNService.shared.execute(.listLocationsRequest, expecting: String.self) { [weak self] result in
            switch result {
            case .success(let model)
                break
            case .failure(let error)
                break
            }
        }
        let request = CNRequest(endpoint: .location)
    }

    private var hasMoreResults: Bool {
        return false
    }
}
