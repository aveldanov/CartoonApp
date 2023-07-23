//
//  CNSearchViewController.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 7/8/23.
//

import UIKit

// Dynamic Search Option View
// Render Results
// Render No Results sero state
// Searching API call

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

            var endpoint: CNEndpoint {
                switch self {
                case .character:
                    return .character
                case .episode:
                    return .episode
                case .location:
                    return .location
                }
            }
        }
        let type: `Type`
    }

    private let searchView: CNSearchView
    private let viewModel: CNSearchViewViewModel

    // MARK: - Init

    init(config: Config) {
        let viewModel = CNSearchViewViewModel(config: config)
        self.viewModel = viewModel
        self.searchView = CNSearchView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.config.type.title
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search", style: .done, target: self, action: #selector(didTapExecuteSearch))

        setupViewHierarchy()
        setupViewLayout()

        searchView.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchView.presentKeyboard()
    }

    @objc
    private func didTapExecuteSearch() {
        viewModel.executeSearch()
    }

    private func setupViewHierarchy() {
        view.addSubview(searchView)
    }

    private func setupViewLayout() {
        searchView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            searchView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - CNSearchViewDelegate

extension CNSearchViewController: CNSearchViewDelegate {
    func cnSearchView(_ searchView: CNSearchView, didSelectOption option: CNSearchInputViewViewModel.DynamicOption) {
        let viewController = CNSearchOptionPickerViewController(option: option) { [weak self] selection in
            print("Did select \(selection)")
            DispatchQueue.main.async {
                self?.viewModel.set(value: selection, for: option)
            }
        }
        viewController.sheetPresentationController?.detents = [.medium()]
        viewController.sheetPresentationController?.prefersGrabberVisible = true
        present(viewController, animated: true)
    }
}
