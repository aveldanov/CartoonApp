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
        setupViewHierarchy()
        setupViewLayout()
    }

    private func addSwiftUIController() {
        let settingsSwiftUIViewController = UIHostingController(
            rootView: CNSettingsView(
                viewModel: CNSettingsViewViewModel(
                    cellViewModels: CNSettingsOption.allCases.compactMap({
                        return CNSettingsCellViewViewModel(type: $0) { [weak self] option in
                            print("[CNSettingsViewController] option", option.displayTitle)
                            self?.handleTap(option: option)
                        }
                    })
                )
            )
        )

        addChild(settingsSwiftUIViewController)
        settingsSwiftUIViewController.didMove(toParent: self)

        self.settingsSwiftUIViewController = settingsSwiftUIViewController

    }

    private func setupViewHierarchy() {
        guard let settingsSwiftUIViewController = self.settingsSwiftUIViewController else {
            return
        }
        view.addSubview(settingsSwiftUIViewController.view)
    }

    private func setupViewLayout() {
        guard let settingsSwiftUIViewController = self.settingsSwiftUIViewController else {
            return
        }
        
        settingsSwiftUIViewController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            settingsSwiftUIViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            settingsSwiftUIViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            settingsSwiftUIViewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            settingsSwiftUIViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }


    private func handleTap(option: CNSettingsOption) {
        // Ensure it runs in the main thread
        guard Thread.current.isMainThread else {
            return
        }

        switch option {
        case .rateApp:
            // Show prompt
            break
        case .contactUs:
            // 
        case .terms:
            <#code#>
        case .privacy:
            <#code#>
        case .apiReference:
            <#code#>
        case .viewSeries:
            <#code#>
        case .viewCode:
            <#code#>
        }
    }
}
