//
//  SparkConfigApp.swift
//  SparkConfig
//
//  Created by robin.lemaire on 15/05/2024.
//

import SwiftUI

@main
struct SparkConfigApp: App {

    // MARK: - Properties

    private let viewModel = AppViewModel()

    // MARK: - Initialization

    init() {
        self.viewModel.loadEnv()
    }

    // MARK: - View

    var body: some Scene {
        WindowGroup {
            VSplitView {
                NavigationStack {
                    VStack(alignment: .leading) {
                        SideBarView()
                    }
                }
                .navigationTitle("Spark Configuration")

                ConsoleView()
            }
        }
    }
}
