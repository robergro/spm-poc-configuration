//
//  RepositoryDetailsView.swift
//  SparkConfig
//
//  Created by robin.lemaire on 16/05/2024.
//

import SwiftUI

struct RepositoryDetailsView: View {

    // MARK: - Properties

    var viewModel: RepositoryDetailsViewModel

    // MARK: - Initialization

    init(repository: Repository) {
        self.viewModel = .init(repository: repository)
    }

    // MARK: - View

    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {

                // Header
                self.headerView

                Divider()

                // Github
                if self.viewModel.showGithubSection {
                    self.githubView

                    Divider()
                }

                // Settings
                self.settingsView

                Divider()

                // Dependencies
                self.dependenciesView
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 24)

            Spacer()
        }
    }

    // MARK: - ViewBuilder

    @ViewBuilder
    private var headerView: some View {
        HStack(spacing: 16) {
            Text(self.viewModel.displayName)
                .font(.title)
                .bold()

            // Redirection buttons
            HStack {
                ForEach(
                    self.viewModel.localRedirectionTypes,
                    id: \.rawValue
                ) { type in

                    Button {
                        self.viewModel.redirect(from: type)
                    } label: {
                        Image(systemName: type.systemImage)
                            .frame(width: 16, height: 16)
                    }
                    .buttonStyle(.plain)
                    .help(Text(type.description))
                }
            }
        }
    }

    @ViewBuilder
    private var githubView: some View {
        VStack(
            alignment: .leading,
            spacing: 16
        ) {
            Text("Github")
                .font(.title2)
                .bold()

            // Redirection Buttons
            HStack {
                ForEach(
                    RepositoryExternalRedirectionType.allCases,
                    id: \.rawValue
                ) { type in

                    Button(type.name) {
                        self.viewModel.redirect(from: type)
                    }
                }
            }
        }
        .padding(.vertical, 12)
    }

    @ViewBuilder
    private var settingsView: some View {
        VStack(
            alignment: .leading,
            spacing: 16
        ) {
            Text("Settings")
                .font(.title2)
                .bold()

            // Executions Buttons
            HStack {
                ForEach(
                    self.viewModel.executionTypes,
                    id: \.rawValue
                ) { type in
                    Button(type.name) {
                        self.viewModel.execute(from: type)
                    }
                }
            }
        }
        .padding(.vertical, 12)
    }

    @ViewBuilder
    private var dependenciesView: some View {
        VStack(
            alignment: .leading,
            spacing: 16
        ) {
            Text("Dependencies")
                .font(.title2)
                .bold()

            // TODO:
//            // Executions Buttons
//            HStack {
//                ForEach(
//                    self.viewModel.executionTypes,
//                    id: \.rawValue
//                ) { type in
//                    Button(type.name) {
//                        self.viewModel.execute(from: type)
//                    }
//                }
//            }
        }
        .padding(.vertical, 12)
    }
}

#Preview {
    RepositoryDetailsView(
        repository: .init(
            type: .app,
            name: "App",
            url: URL(fileURLWithPath: "")
        )
    )
}
