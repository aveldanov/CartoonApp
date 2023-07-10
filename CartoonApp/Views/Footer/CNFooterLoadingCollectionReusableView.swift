//
//  CNFooterLoadingCollectionReusableView.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 7/2/23.
//

import UIKit

final class CNFooterLoadingCollectionReusableView: UICollectionReusableView {
    
    static let identifier = "CNFooterLoadingCollectionReusableView"

    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        setupViewHierarchy()
        setupViewLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViewHierarchy() {
        addSubview(spinner)
    }

    private func setupViewLayout() {
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    public func startAnimating() {
        spinner.startAnimating()
    }
}
