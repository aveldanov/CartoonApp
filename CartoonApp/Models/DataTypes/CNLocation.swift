//
//  CNLocation.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 6/11/23.
//

import Foundation

struct CNLocation: Codable {

    let id: Int
    let name: String
    let type: String
    let dimension: String
    let residents: [String]
    let url: String
    let created: String
}
