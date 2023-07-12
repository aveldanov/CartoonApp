//
//  CNCharacterStatus.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 6/18/23.
//

import Foundation

enum CNCharacterStatus: String, Codable {
    
    // 'Alive', 'Dead' or 'unknown'
    case alive = "Alive"
    case dead = "Dead"
    case `unknown` = "unknown"

    var text: String {
        switch self {
        case .alive, .dead:
            return rawValue
        case .unknown:
            return "Unknown"
        }
    }
}
