//
//  CNLocationTableViewCell.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 7/12/23.
//

import UIKit

final class CNLocationTableViewCell: UITableViewCell {
    static let identifier = "CNLocationTableViewCell"


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

    }

    public func configure(with viewModel: CNLocationTableViewCellViewModel) {

    }
}
