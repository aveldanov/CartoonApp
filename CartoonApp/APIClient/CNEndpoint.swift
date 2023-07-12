//
//  CNEndpoint.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 6/18/23.
//

import Foundation

/// Represents unique API endpoints
@frozen enum CNEndpoint: String, CaseIterable, Hashable {

    case character
    case location
    case episode
}
