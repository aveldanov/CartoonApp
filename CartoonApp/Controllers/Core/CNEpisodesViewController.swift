//
//  CNEpisodeViewController.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 6/11/23.
//

import UIKit

final class CNEpisodesViewController: UIViewController {

    private let episodeListView = CNEpisodeListView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Episodes"
        episodeListView.delegate = self
        addSearchButton()
        setupViewHierarchy()
        setupViewLayout()
    }

    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }

    @objc
    private func didTapSearch() {

    }

    private func setupViewHierarchy() {
        view.addSubview(episodeListView)
    }

    private func setupViewLayout() {
        NSLayoutConstraint.activate([
            episodeListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            episodeListView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            episodeListView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            episodeListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - CNEpisodeListViewDelegate

extension CNEpisodesViewController: CNEpisodeListViewDelegate {

    func cnEpisodeListView(_ episodeListView: CNEpisodeListView, didSelectEpisode episode: CNEpisode) {
        // Open detail controller for the episode
        let detailViewController = CNEpisodeDetailViewController(url: URL(string: episode.url))
        detailViewController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
