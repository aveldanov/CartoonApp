//
//  CNLocationDetailViewController.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 7/14/23.
//

import UIKit

class CNLocationDetailViewController: UIViewController {

    private let locaiton: CNLocation

    // MARK: - Init

    init(locaiton: CNLocation) {
        self.locaiton = locaiton
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Location"
        view.backgroundColor = .red
    }
}
