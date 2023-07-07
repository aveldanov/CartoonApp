//
//  CNEpisode.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 6/11/23.
//

import Foundation


struct CNEpisode: Codable, CNEpisodeDataRenderProtocol {
    let id: Int
    let name: String
    let air_date: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String

}
