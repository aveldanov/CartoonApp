//
//  CNSettingsCellViewViewModel.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 7/10/23.
//

import UIKit

struct CNSettingsCellViewViewModel: Identifiable {

    let id = UUID()

    public let type: CNSettingsOption
    public let onTapHandler: (CNSettingsOption) -> Void

    // MARK: - Init

    init(type: CNSettingsOption, onTapHandler: @escaping (CNSettingsOption) -> Void) {
        self.type = type
        self.onTapHandler = onTapHandler
    }

    // MARK: - Public properties and methods

    public var image: UIImage? {
        return type.iconImage
    }

    public var title: String {
        return type.displayTitle
    }

    public var iconContainerColor: UIColor {
        return type.iconContainerColor
    }
}
