//
//  CNGetAllLocationsResponse.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 7/12/23.
//

import Foundation

struct CNGetAllLocationsResponse: Codable {

    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }

    let info: Info
    let results: [CNLocation]
}
