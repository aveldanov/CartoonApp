//
//  CNCharacterEpisodeCollectionViewCell.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 7/4/23.
//

import UIKit

class CNCharacterEpisodeCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CNCharacterEpisodeCollectionViewCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemCyan
        contentView.layer.cornerRadius = 8
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    private func setupViewHierarchy() {

    }

    private func setupViewLayout() {

    }

    public func configure(with viewModel: CNCharacterEpisodeCollectionViewViewModel) {
        viewModel.registerForData { data in
            print("DATA0000000",data.name, data.air_date, data.episode)
        }
        viewModel.fetchEpisode()
    }

}
