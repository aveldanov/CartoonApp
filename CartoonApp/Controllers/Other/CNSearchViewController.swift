//
//  CNSearchViewController.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 7/8/23.
//

import UIKit

/// Configurable Search View Controller
final class CNSearchViewController: UIViewController {

    // MARK: - Search Configuration
    struct Config {
        enum `Type` {
            case character // name status gender
            case episode // name
            case location //name type

            var title: String {
                switch self {
                case .character:
                    return "Search Characters"
                case .episode:
                    return "Search Episodes"
                case .location:
                    return "Search Locations"
                }
            }
        }
        let type: `Type`
    }

    private let config: Config

    // MARK: - Init

    init(config: Config) {
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = config.type.title
        view.backgroundColor = .systemBackground
    }
}
