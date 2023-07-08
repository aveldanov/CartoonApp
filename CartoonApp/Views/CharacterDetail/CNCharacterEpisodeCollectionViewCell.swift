//
//  CNCharacterEpisodeCollectionViewCell.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 7/4/23.
//

import UIKit

class CNCharacterEpisodeCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CNCharacterEpisodeCollectionViewCell"

    private let episodeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .regular)
        return label
    }()

    private let airDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .light)
        return label
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .tertiarySystemBackground
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.systemBlue.cgColor

        setupViewHierarchy()
        setupViewLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        episodeLabel.text = nil
        nameLabel.text = nil
        airDateLabel.text = nil
    }

    private func setupViewHierarchy() {
        contentView.addSubviews(episodeLabel, nameLabel, airDateLabel)
    }

    private func setupViewLayout() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        episodeLabel.translatesAutoresizingMaskIntoConstraints = false
        airDateLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            episodeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant:  10),
            episodeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            episodeLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            episodeLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.3),

            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant:  10),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            nameLabel.topAnchor.constraint(equalTo: episodeLabel.bottomAnchor),
            nameLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.3),

            airDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant:  10),
            airDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            airDateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            airDateLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.3)
        ])
    }

    public func configure(with viewModel: CNCharacterEpisodeCollectionViewViewModel) {
        viewModel.registerForData { [weak self] data in
            self?.nameLabel.text = data.name
            self?.episodeLabel.text = "Episode \(data.episode)"
            self?.airDateLabel.text = "Aired on \(data.air_date)"

        }
        viewModel.fetchEpisode()
    }

}
