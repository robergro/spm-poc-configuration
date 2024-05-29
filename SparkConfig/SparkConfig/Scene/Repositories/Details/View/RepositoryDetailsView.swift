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

    let columns = [
        GridItem(.adaptive(minimum: 250, maximum: 300), alignment: .topLeading),
        GridItem(.fixed(10), alignment: .topLeading)
    ]

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
        .redacted(reason: self.viewModel.isLoading ? .placeholder : [])
        .onAppear {
            Task {
                await self.viewModel.fetch()
            }
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
                        Task {
                            await self.viewModel.execute(from: type)
                        }
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
            HStack {
                Text("Dependencies")
                    .font(.title2)
                    .bold()

                Button {
                    Task {
                        await self.viewModel.reloadDependencies()
                    }
                } label: {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .frame(width: 16, height: 16)
                }
                .buttonStyle(.plain)
                .help(Text("Reload dependencies"))

                Spacer()
            }

            HStack {
                Text("Select dependencies to switch to local or external source:")
                Spacer()
                Button(self.viewModel.dependenciesNextSelectionStatus.title) {
                    self.viewModel.selectAllDependencies()
                }
            }

            ScrollView {
                LazyVGrid(columns: self.columns, alignment: .leading, spacing: 20) {
                    ForEach(self.viewModel.dependencies, id: \.self) { dependency in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Image(systemName: dependency.systemImage)

                                Group {
                                    Text(dependency.name) +
                                    Text(" (\(dependency.type.rawValue))")
                                        .italic()
                                }
                            }
                        }
                        .padding(8)
                        .background(self.viewModel.dependencyIsSelected(dependency) ? Color.gray.opacity(0.5) : Color.clear)
                        .cornerRadius(8.0)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            self.viewModel.setDependencyIsSelected(dependency)
                        }
                    }
                }
                .padding(.horizontal)
                .redacted(reason: self.viewModel.dependenciesIsLoading ? .placeholder : [])
            }

            HStack {
                Button("Switch selection to local dependencies") {
                    Task {
                        await self.viewModel.switchSelectionsToLocalDependencies()
                    }
                }

                Button("Switch selection to external dependencies") {
                    Task {
                        await self.viewModel.switchSelectionsToExternalDependencies()
                    }
                }
            }
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
