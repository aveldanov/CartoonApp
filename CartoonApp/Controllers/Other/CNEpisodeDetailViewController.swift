//
//  CNEpisodeDetailViewController.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 7/6/23.
//

import UIKit

/// View Controller to show detail about a single episode
final class CNEpisodeDetailViewController: UIViewController {

    private let url: URL?


    init(url: URL?) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Episode"
        view.backgroundColor = .red
    }
}
