//
//  CNEpisodeDetailViewController.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 7/6/23.
//

import UIKit

/// View Controller to show detail about a single episode
final class CNEpisodeDetailViewController: UIViewController {

    private let viewModel: CNEpisodeDetailViewViewModel

    private let episodeDetailView = CNEpisodeDetailView()

    init(url: URL?) {
        self.viewModel = .init(endpointUrl: url)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Episode"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))

        setupViewHierarchy()
        setupViewLayout()
    }

    @objc
    private func didTapShare() {
        // Share episode info

    }
    
    private func setupViewHierarchy() {
        view.addSubview(episodeDetailView)
    }

    private func setupViewLayout() {
        episodeDetailView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            episodeDetailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            episodeDetailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            episodeDetailView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            episodeDetailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
