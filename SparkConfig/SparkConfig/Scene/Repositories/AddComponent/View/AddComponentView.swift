//
//  AddComponentView.swift
//  SparkConfig
//
//  Created by robin.lemaire on 15/05/2024.
//

import SwiftUI

struct AddComponentView: View {

    // MARK: - Properties
    
    @Bindable private var viewModel: AddComponentViewModel
    @Environment (\.showingView) private var showingView

    var refresh: (() -> Void)?

    // MARK: - Initialization

    init(
        viewModel: AddComponentViewModel,
        refresh: (() -> Void)?
    ) {
        self.viewModel = viewModel
        self.refresh = refresh
    }

    // MARK: - View

    var body: some View {
        GroupBox(content: {
            VStack(alignment: .leading, spacing: 24) {

                VStack(alignment: .leading) {
                    Group {
                        Text("Requirement: ").bold() +
                        Text("You need to have ") +
                        Text("gh").bold() +
                        Text(" installed on your mac.")
                    }

                    if let githubDocURL = self.viewModel.githubDocURL {
                        Link("Show details", destination: githubDocURL)
                    }
                }

                VStack(alignment: .leading) {
                    Group {
                        Text("Requirement: ").bold() +
                        Text("You need to have set a ") +
                        Text("Github Token").bold() +
                        Text(" on the settings of this app.")
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Name of the component")
                        .font(.title3)
                        .bold()
                    
                    Group {
                        Text("Rules : ").bold() +
                        Text("no space, use \"-\" instead to separate each word.") +
                        Text("\n") +
                        Text("Example : ") +
                        Text("progress-bar, tag, text-view, ...")
                    }
                    .italic()
                    .opacity(0.8)

                    TextField(
                        "Name of the component",
                        text: self.$viewModel.componentName
                    )

                    Group {
                        Text("Name of the repository : ") +
                        Text(self.viewModel.repositoryName)
                            .bold()
                    }
                    .font(.footnote)
                }
            }
            .padding(16)
        }, label: {
            let type = RepositoriesToolbarType.addComponentRepo
            Label(type.title, systemImage: type.systemImage)
                .font(.title)
                .padding(.bottom, 8)
        })
        .padding(8)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Close") {
                    self.showingView.wrappedValue = false
                }
            }

            ToolbarItem(placement: .confirmationAction) {
                if self.viewModel.isLoading {
                    ProgressView()
                } else {
                    Button("Create") {
                        Task {
                            await self.viewModel.createRepository()
                            self.showingView.wrappedValue = false
                        }
                    }
                    .disabled(self.viewModel.componentName.isEmpty)
                }
            }
        }
    }
}
