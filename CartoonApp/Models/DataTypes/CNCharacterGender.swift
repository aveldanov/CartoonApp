//
//  CNCharacterGender.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 6/18/23.
//

import Foundation
//'Female', 'Male', 'Genderless' or 'unknown'

enum CNCharacterGender: String, Codable {
    
    case female = "Female"
    case male = "Male"
    case genderless = "Genderless"
    case `unknown` = "unknown"
}
