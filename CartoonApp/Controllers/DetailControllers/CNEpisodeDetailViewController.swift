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
    }

    private func setupViewHierarchy() {
        view.addSubview(episodeDetailView)
    }

    private func setupViewLayout() {
        NSLayoutConstraint.activate([


        ])

    }
}
