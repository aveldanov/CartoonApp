//
//  CNCharacterDetailViewViewModel.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 7/1/23.
//

import UIKit

final class CNCharacterDetailViewViewModel {
    
    private let character: CNCharacter

    // enum and associated values
    enum SectionType {
        case photo(viewModel: CNCharacterPhotoCollectionViewViewModel)
        case information(viewModels: [CNCharacterInformationCollectionViewViewModel])
        case episodes(viewModels: [CNCharacterEpisodeCollectionViewViewModel])
    }

    public var sections: [SectionType] = []

    // MARK: - Initilizer

    init(character: CNCharacter) {
        self.character = character
        setupSections()
    }

    private var requestUrl: URL? {
        return URL(string: character.url)
    }

    private func setupSections() {
        sections = [
            .photo(viewModel: .init(imageUrl: URL(string: character.image))),
            .information(viewModels: [
                .init(value: character.status.rawValue, title: "Status"),
                .init(value: character.gender.rawValue, title: "Gender"),
                .init(value: character.type, title: "Type"),
                .init(value: character.species, title: "Species"),
                .init(value: character.origin.name, title: "Origin"),
                .init(value: character.location.name, title: "Location"),
                .init(value: character.created, title: "Created"),
                .init(value: "\(character.episode.count)", title: "Total Episodes")
            ]),
            .episodes(viewModels:
                character.episode.compactMap({
                    return CNCharacterEpisodeCollectionViewViewModel(episodeDataUrl: URL(string: $0))
                })
            )
        ]
    }

    public var title: String {
        character.name.uppercased()
    }

    // MARK: - Layouts

    public func createPhotoSectionLayout() -> NSCollectionLayoutSection  {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(0.5)),
            subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }

    public func createInformationSectionLayout() -> NSCollectionLayoutSection  {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(150)),
            subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }

    public func createEpisodeSectionLayout() -> NSCollectionLayoutSection  {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 8)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.8),
                heightDimension: .absolute(150)),
            subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging // horizontal scroll
        return section
    }
}