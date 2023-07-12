//
//  CNSettingsViewController.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 6/11/23.
//

import SwiftUI
import UIKit

final class CNSettingsViewController: UIViewController {

    private var settingsSwiftUIViewController: UIHostingController<CNSettingsView>?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Settings"

        addSwiftUIController()

    }

    private func addSwiftUIController() {
        let settingsSwiftUIViewController = UIHostingController(
            rootView: CNSettingsView(
                viewModel: CNSettingsViewViewModel(
                    cellViewModels: CNSettingsOption.allCases.compactMap({
                        return CNSettingsCellViewViewModel(type: $0) { option in
                            print("option", option.displayTitle)
                        }
                    })
                )
            )
        )

        addChild(settingsSwiftUIViewController)
        settingsSwiftUIViewController.didMove(toParent: self)
//        setupViewHierarchy(settingsSwiftUIViewController: settingsSwiftUIViewController)
//        setupViewLayout(settingsSwiftUIViewController: settingsSwiftUIViewController)
        view.addSubview(settingsSwiftUIViewController.view)

        settingsSwiftUIViewController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            settingsSwiftUIViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            settingsSwiftUIViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            settingsSwiftUIViewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            settingsSwiftUIViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        self.settingsSwiftUIViewController = settingsSwiftUIViewController

    }

    private func setupViewHierarchy(settingsSwiftUIViewController: UIHostingController<CNSettingsView>) {
//        guard let settingsSwiftUIViewController = self.settingsSwiftUIViewController else {
//            return
//        }
//        view.addSubview(settingsSwiftUIViewController.view)
    }

    private func setupViewLayout(settingsSwiftUIViewController: UIHostingController<CNSettingsView>) {
//        guard let settingsSwiftUIViewController = self.settingsSwiftUIViewController else {
//            return
//        }
        
//        settingsSwiftUIViewController.view.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            settingsSwiftUIViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            settingsSwiftUIViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//            settingsSwiftUIViewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
//            settingsSwiftUIViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
//        ])
    }
}
