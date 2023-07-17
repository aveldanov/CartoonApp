//
//  CNSearchViewViewModel.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 7/14/23.
//

import Foundation


// Responsibilities
// - show results
// - show no results view
// - kick off
final class CNSearchViewViewModel {

    let config: CNSearchViewController.Config

    var optionMapUpdateBlock: (((option: CNSearchInputViewViewModel.DynamicOption, value: String))->Void)?

    private var optionMap: [CNSearchInputViewViewModel.DynamicOption: String] = [:]

    // MARK: - Init

    init(config: CNSearchViewController.Config) {
        self.config = config
    }

    // MARK: - Public

    public func set(value: String, for option: CNSearchInputViewViewModel.DynamicOption) {
        optionMap[option] = value
        let tuple = (option, value)
        optionMapUpdateBlock?(tuple)
    }

    public func registerOptionChangeBlock(_ block: @escaping ((option: CNSearchInputViewViewModel.DynamicOption, value: String))->Void) {
        self.optionMapUpdateBlock = block
    }
}
