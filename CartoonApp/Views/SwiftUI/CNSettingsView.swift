//
//  CNSettingsView.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 7/10/23.
//

import SwiftUI

struct CNSettingsView: View {

    let viewModel: CNSettingsViewViewModel

    init(viewModel: CNSettingsViewViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        List(viewModel.cellViewModels) { viewModel in
            HStack {
                if let image = viewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color.white)
                        .padding(8)
                        .background(Color(viewModel.iconContainerColor))
                        .cornerRadius(6)
                }
                Text(viewModel.title)
                    .padding(.leading, 10)
            }
            .padding(.bottom, 3)
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
