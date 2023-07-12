//
//  CNCharacter.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 6/11/23.
//

import Foundation

struct CNCharacter: Codable {
    
    let id: Int
    let name: String
    let status: CNCharacterStatus
    let species: String
    let type: String
    let gender: CNCharacterGender
    let origin: CNOrigin
    let location: CNSingleLocation
    let image: String
    let episode: [String]
    let url: String
    let created: String
}
