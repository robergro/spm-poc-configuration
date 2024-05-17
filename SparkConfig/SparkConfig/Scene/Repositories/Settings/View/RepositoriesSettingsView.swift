//
//  RepositoriesSettingsView.swift
//  SparkConfig
//
//  Created by robin.lemaire on 15/05/2024.
//

import SwiftUI

struct RepositoriesSettingsView: View {

    // MARK: - Properties

    @Bindable private var viewModel: RepositoriesSettingsViewModel
    @Environment (\.showingView) private var showingView

    var refresh: (() -> Void)?

    // MARK: - Initialization

    init(
        viewModel: RepositoriesSettingsViewModel,
        refresh: (() -> Void)?
    ) {
        self.viewModel = viewModel
        self.refresh = refresh
    }

    // MARK: - View

    var body: some View {
        GroupBox(content: {
            Form {
                Section(content: {
                    TextField(
                        "",
                        text: self.$viewModel.githubToken,
                        prompt: Text("Github Token")
                    )
                    .padding(.bottom, 14)
                }, header: {
                    HStack {
                        Text("Github Token").bold()
                        if let githubDocURL = self.viewModel.githubDocURL {
                            Link("Show documentation", destination: githubDocURL)
                        }
                    }
                })

                ForEach(
                    RepositoriesSettingsLocationType.allCases,
                    id: \.rawValue
                ) { type in

                    Section(content: {
                        self.pathView(type: type)
                    }, header: {
                        Text(type.title).bold()
                    })
                }
            }
            .padding(16)
        }, label: {
            let type = RepositoriesToolbarType.setting
            Label(type.title, systemImage: type.systemImage)
                .font(.title)
                .padding(.bottom, 8)
        })
        .padding(8)
        .toolbar {
            ToolbarItem(placement: .destructiveAction) {
                Button("Reset") {
                    self.viewModel.reset()
                }
            }

            ToolbarItem(placement: .confirmationAction) {
                Button("Close") {
                    self.viewModel.close()
                    self.showingView.wrappedValue = false
                }
            }
        }
    }

    // MARK: - ViewBuilder

    @ViewBuilder
    private func pathView(type: RepositoriesSettingsLocationType) -> some View {
        let pathURL = switch type {
        case .repositories: self.viewModel.repositoriesLocationURL
        case .derivedData: self.viewModel.derivedDataLocationURL
        }

        HStack(spacing: 10) {
            Text(pathURL.path)
                .textSelection(.enabled)
                .italic()
                .border(.gray.opacity(0.2), width: 0.5)

            Button("Update") {
                let panel = NSOpenPanel()
                panel.directoryURL = pathURL
                panel.allowsMultipleSelection = false
                panel.canChooseFiles = false
                panel.canChooseDirectories = true
                guard panel.runModal() == .OK,
                      let url = panel.url else {
                    return
                }

                switch type {
                case .repositories:
                    self.viewModel.setRepositoriesLocationURL(url)
                    self.refresh?()
                case .derivedData:
                    self.viewModel.setDerivedDataLocationURL(url)
                }
            }
        }
        .padding(.bottom, type.isLastElement ? 0 : 14)
    }
}
