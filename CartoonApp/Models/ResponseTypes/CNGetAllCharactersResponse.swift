//
//  CNGetAllCharactersResponse.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 6/21/23.
//

import Foundation

struct CNGetAllCharactersResponse: Codable {

    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }

    let info: Info
    let results: [CNCharacter]
}
