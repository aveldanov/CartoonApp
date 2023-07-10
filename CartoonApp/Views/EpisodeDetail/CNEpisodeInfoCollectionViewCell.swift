//
//  CNEpisodeInfoCollectionViewCell.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 7/9/23.
//

import UIKit

final class CNEpisodeInfoCollectionViewCell: UICollectionViewCell {
    static let identifier = "CNEpisodeInfoCollectionViewCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        setupLayer()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    public func configure(with viewModel: CNEpisodeInfoCollectionViewCellViewModel) {

    }

    private func setupLayer() {
        layer.cornerRadius = 8
        layer.masksToBounds = true
        layer.borderColor = UIColor.secondaryLabel.cgColor
        layer.borderWidth = 1
    }
}
