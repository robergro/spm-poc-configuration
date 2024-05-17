//
//  RepositoriesToolbarViewModifier.swift
//  SparkConfig
//
//  Created by robin.lemaire on 15/05/2024.
//

import SwiftUI

struct RepositoriesToolbarViewModifier: ViewModifier {

    // MARK: - Properties

    private var settingsViewModel = RepositoriesSettingsViewModel()
    private var addComponentViewModel = AddComponentViewModel()

    @State private var isSettingsVisible = false
    @State private var isAddComponentVisible = false
    let refresh: (() -> Void)?

    // MARK: - Initialization

    init(
        refresh: (() -> Void)?
    ) {
        self.refresh = refresh
    }

    // MARK: - View

    public func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItemGroup {
                    ForEach(
                        RepositoriesToolbarType.allCases,
                        id: \.rawValue
                    ) { type in
                        Button {
                            switch type {
                            case .addComponentRepo:
                                self.isAddComponentVisible = true
                            case .refresh:
                                self.refresh?()
                            case .setting:
                                self.isSettingsVisible = true
                            }
                        } label: {
                            Image(systemName: type.systemImage)
                        }
                        .help(Text(type.description))
                    }
                }
            }
            .sheet(isPresented: self.$isSettingsVisible) {
                RepositoriesSettingsView(
                    viewModel: self.settingsViewModel,
                    refresh: self.refresh
                )
                .environment(\.showingView, self.$isSettingsVisible)
            }
            .sheet(isPresented: self.$isAddComponentVisible) {
                AddComponentView(
                    viewModel: self.addComponentViewModel,
                    refresh: self.refresh
                )
                    .environment(\.showingView, self.$isAddComponentVisible)
            }
    }
}
