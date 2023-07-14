//
//  CNLocationTableViewCellViewModel.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 7/12/23.
//

import Foundation

struct CNLocationTableViewCellViewModel: Hashable, Equatable {

    private let location: CNLocation

    init(location: CNLocation) {
        self.location = location
    }

    public var name: String {
        return location.name
    }

    public var type: String {
        return "Type: \(location.type)"
    }

    public var dimension: String {
        return location.dimension
    }

    static func == (lhs: CNLocationTableViewCellViewModel, rhs: CNLocationTableViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue // you can do: lhs.location.id == rhs.location.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(location.id)
        hasher.combine(name)
        hasher.combine(type)
        hasher.combine(dimension)
    }
}
