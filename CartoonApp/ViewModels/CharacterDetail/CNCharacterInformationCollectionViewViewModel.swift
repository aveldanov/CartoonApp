//
//  CNCharacterInformationCollectionViewViewModel.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 7/4/23.
//

import UIKit

final class CNCharacterInformationCollectionViewViewModel {

    private let type: `Type`
    private let value: String

    static let dateFormatter: DateFormatter = {
        // Formatter
        // 2017-11-04T18:50:21.651Z

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSZ"
        formatter.timeZone = .current
        return formatter
    }()

    static let shortDateFormatter: DateFormatter = {
        // Formatter
        // 2017-11-04T18:50:21.651Z

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()

    public var title: String {
        type.displayTitle
    }

    public var displayValue: String {
        if value.isEmpty {
            return "None"
        }
        if type == .created, let date = Self.dateFormatter.date(from: value) {
            // Nov 4, 2017 at 11:50 AM
            return Self.shortDateFormatter.string(from: date)
        }

        return value
    }

    public var iconImage: UIImage? {
        return type.iconImage
    }

    public var tintColor: UIColor {
        return type.tintColor
    }

    enum `Type`: String {
        case status
        case gender
        case type
        case species
        case origin
        case location
        case created
        case episodeCount


        var tintColor: UIColor {
            switch self {
            case .status:
                return .systemBlue
            case .gender:
                return .systemPink
            case .type:
                return .systemYellow
            case .species:
                return .systemPurple
            case .origin:
                return .systemCyan
            case .location:
                return .systemMint
            case .created:
                return .systemOrange
            case .episodeCount:
                return .systemBrown
            }
        }

        var iconImage: UIImage? {
            switch self {
            case .status:
                return UIImage(systemName: "bell")
            case .gender:
                return UIImage(systemName: "bell")
            case .type:
                return UIImage(systemName: "bell")
            case .species:
                return UIImage(systemName: "bell")
            case .origin:
                return UIImage(systemName: "bell")
            case .location:
                return UIImage(systemName: "bell")
            case .created:
                return UIImage(systemName: "bell")
            case .episodeCount:
                return UIImage(systemName: "bell")
            }
        }

        var displayTitle: String {
            switch self {
            case .status,
                    .gender,
                    .type,
                    .species,
                    .origin,
                    .location,
                    .created:
                return rawValue.uppercased()

            case .episodeCount:
                return "EPISODE COUNT"
            }
        }
    }

    init(type: `Type`, value: String) {
        self.value = value
        self.type = type
    }
}
