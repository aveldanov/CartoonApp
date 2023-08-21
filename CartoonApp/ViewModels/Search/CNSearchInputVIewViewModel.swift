//
//  CNSearchInputVIewViewModel.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 7/14/23.
//

import Foundation


final class CNSearchInputViewModel{

    private let type: CNSearchViewController.Config.`Type`

    enum DynamicOption: String {
        case status = "Status"
        case gender = "Gender"
        case locationType = "Location Type"

        var queryArgument: String {
            switch self {
            case .status:
                return "status"
            case .gender:
                return "gender"
            case .locationType:
                return "type"
            }
        }

        var choices: [String] {
            switch self {
            case .status:
                return ["alive", "dead", "unknown"]
            case .gender:
                return ["male", "female", "genderless", "unknown"]
            case .locationType:
                return ["cluster", "planet", "microverse"]

            }
        }
    }

    init(type: CNSearchViewController.Config.`Type`) {
        self.type = type
    }

    // MARK: - Public Methods

    /*
     case character // name status gender
     case episode // name
     case location //name type
     */

    public var hasDynamicOptions: Bool {
        switch type {
        case .character, .location:
            return true
        case .episode:
            return false
        }
    }

    public var options: [DynamicOption] {
        switch type {
        case .character:
            return [.status, .gender]
        case .location:
            return [.locationType]
        case .episode:
            return []
        }
    }

    public var searchPlaceholderText: String {
        switch type {
        case .character:
            return "Character Name"
        case .location:
            return "Location Name"
        case .episode:
            return "Episode Title"
        }
    }
}
