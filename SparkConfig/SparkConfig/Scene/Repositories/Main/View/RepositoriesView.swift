//
//  RepositoriesView.swift
//  SparkConfig
//
//  Created by robin.lemaire on 15/05/2024.
//

import SwiftUI

struct RepositoriesView: View {

    // MARK: - Properties

    @Bindable private var viewModel = RepositoriesViewModel()

    // MARK: - View

    var body: some View {
        NavigationView {
            List(self.viewModel.searchResults, id: \.self) { repository in
                NavigationLink(destination: RepositoryDetailsView(repository: repository)) {
                    HStack {
                        Image(systemName: repository.systemImage)
                            .frame(width: 30)

                        Text(repository.name)
                            .font(.headline)

                        Spacer()

                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                }
            }
            .frame(minWidth: 360)
            .searchable(text: self.$viewModel.searchText)
            .modifier(RepositoriesToolbarViewModifier(refresh: {
                self.viewModel.refresh()
            }))
        }
        .navigationTitle("Repositories")

    }
}

#Preview {
    RepositoriesView()
}
