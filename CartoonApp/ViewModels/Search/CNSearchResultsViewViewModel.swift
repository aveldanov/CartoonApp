//
//  CNSearchResultsViewViewModel.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 7/22/23.
//

import Foundation

protocol CNSearchResultsRepresentableProtocol {
    associatedtype ResultType
    var results: [ResultType] { get }
}

struct CNSearchResultsViewViewModel<T>: CNSearchResultsRepresentableProtocol {
    typealias ResultType = T
    var results: [ResultType]

}
