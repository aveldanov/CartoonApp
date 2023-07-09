//
//  CNEpisodeDetailView.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 7/7/23.
//

import UIKit

final class CNEpisodeDetailView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViewHierarchy() {
        translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupViewLayout() {

    }

}
