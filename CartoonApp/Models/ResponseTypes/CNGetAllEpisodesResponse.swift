//
//  CNGetAllEpisodesResponse.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 7/7/23.
//

import Foundation

struct CNGetAllEpisodesResponse: Codable {
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }

    let info: Info
    let results: [CNEpisode]
}
