//
//  CNSearchResultsViewViewModel.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 7/22/23.
//

import Foundation

enum CNSearchResultsViewViewModel {
    case characters([CNCharacterCollectionViewCellViewModel])
    case episodes([CNCharacterEpisodeCollectionViewViewModel])
    case locations([CNLocationTableViewCellViewModel])
}
