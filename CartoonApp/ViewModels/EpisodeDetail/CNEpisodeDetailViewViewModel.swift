//
//  CNEpisodeDetailViewViewModel.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 7/7/23.
//

import UIKit

class CNEpisodeDetailViewViewModel {

    private let endpointUrl: URL?

    init(endpointUrl: URL?) {
        self.endpointUrl = endpointUrl
        fetchEpisodeData()
    }

    public func fetchEpisodeData() {
        guard let url = endpointUrl, let request = CNRequest(url: url) else {
            return
        }

        CNService.shared.execute(request, expecting: CNEpisode.self) { request in
            switch request {
            case .success(let success):
                print(success)
            case .failure(let failure):
                print(failure)
            }
        }
    }
}
