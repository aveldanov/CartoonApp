//
//  CNSearchResultType.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 9/30/23.
//

import Foundation

enum CNSearchResultType {
    case characters([CNCharacterCollectionViewCellViewModel])
    case episodes([CNCharacterEpisodeCollectionViewViewModel])
    case locations([CNLocationTableViewCellViewModel])
}
