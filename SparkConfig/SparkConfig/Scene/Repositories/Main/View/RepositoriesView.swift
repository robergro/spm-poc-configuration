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

    @State private var selectedRepository: Repository?

    // MARK: - View

    var body: some View {
        NavigationSplitView {
            Group {
                
                if self.viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(.linear)
                        .padding(.all)
                } else {
                    List(self.viewModel.searchResults, selection: self.$selectedRepository) { repository in
                        HStack {
                            Image(systemName: repository.systemImage)
                                .frame(width: 30)

                            Text(repository.name)
                                .font(.headline)

                            Spacer()

                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .tag(repository)
                    }
                }
            }
            .frame(minWidth: 360)
            .searchable(text: self.$viewModel.searchText)
            .modifier(RepositoriesToolbarViewModifier(refresh: {
                Task {
                    await self.viewModel.refresh()
                }
            }))
            .redacted(reason: self.viewModel.isLoading ? .placeholder : [])
            .navigationTitle("Repositories")
        } detail: {
            if let selectedRepository = self.selectedRepository {
                RepositoryDetailsView(repository: selectedRepository)
            } else {
                EmptyView()
            }
        }
        .onAppear {
            Task {
                await self.viewModel.fetch()
            }
        }
    }
}

#Preview {
    RepositoriesView()
}
