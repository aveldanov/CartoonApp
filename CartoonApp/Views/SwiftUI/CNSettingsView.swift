//
//  CNSettingsView.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 7/10/23.
//

import SwiftUI

struct CNSettingsView: View {

    let viewModel: CNSettingsViewViewModel?

    init(viewModel: CNSettingsViewViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ScrollView(.vertical) {
            ForEach(strings, id: \.self) { string in
                Text(string)
            }
        }
    }
}

struct CNSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        CNSettingsView(viewModel: .init(cellViewModels: CNSettingsOption.allCases.compactMap({

            return CNSettingsCellViewViewModel(type: $0)
        })))
    }
}
