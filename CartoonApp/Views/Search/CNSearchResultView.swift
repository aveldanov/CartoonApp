//
//  CNSearchResultView.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 7/22/23.
//

import UIKit

/// Shows search results UI(table or collection as needed)
final class CNSearchResultView: UIView {

    private var viewModel: CNSearchResultsViewViewModel? {
        didSet {
            self.processViewModel()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        isHidden = true
        backgroundColor = .red
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViewHierarchy() {

    }


    private func setupViewLayout() {

    }

    private func processViewModel() {
        guard let viewModel = viewModel else {
            return
        }

        switch viewModel {
        case .characters(let viewModels):
            break
        case .locations(let viewModels):
            break
        case .episodes(let viewModels):
            break
        }

    }

    public func configure(with viewModel: CNSearchResultsViewViewModel) {
        self.viewModel = viewModel
    }
}
