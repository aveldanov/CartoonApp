//
//  CNSettingsViewController.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 6/11/23.
//

import SwiftUI
import UIKit

final class CNSettingsViewController: UIViewController {

    private let settingsSwiftUIViewController = UIHostingController(
        rootView: CNSettingsView(
            viewModel: CNSettingsViewViewModel(
                cellViewModels: CNSettingsOption.allCases.compactMap({
                    return CNSettingsCellViewViewModel(type: $0)
                })
            )
        )
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Settings"

        addSwiftUIController()
        setupViewHierarchy()
        setupViewLayout()
    }

    private func addSwiftUIController() {
        addChild(settingsSwiftUIViewController)
        settingsSwiftUIViewController.didMove(toParent: self)
    }

    private func setupViewHierarchy() {
        view.addSubview(settingsSwiftUIViewController.view)
    }

    private func setupViewLayout() {
        settingsSwiftUIViewController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            settingsSwiftUIViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            settingsSwiftUIViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            settingsSwiftUIViewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            settingsSwiftUIViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
