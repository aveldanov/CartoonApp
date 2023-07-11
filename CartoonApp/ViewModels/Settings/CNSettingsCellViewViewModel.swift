//
//  CNSettingsCellViewViewModel.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 7/10/23.
//

import UIKit

struct CNSettingsCellViewViewModel: Identifiable, Hashable {

    let id = UUID()

    private let type: CNSettingsOption

    // MARK: - Init

    init(type: CNSettingsOption) {
        self.type = type
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
