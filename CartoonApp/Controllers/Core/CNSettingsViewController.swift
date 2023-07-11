//
//  CNSettingsViewController.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 6/11/23.
//

import UIKit

final class CNSettingsViewController: UIViewController {

    private let viewModel = CNSettingsViewViewModel(cellViewModels: CNSettingsOption.allCases.compactMap({
        return CNSettingsCellViewViewModel(type: $0)
    }))

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Settings"
    }

}
