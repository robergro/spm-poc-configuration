//
//  RepositoriesToolbarType.swift
//  SparkConfig
//
//  Created by robin.lemaire on 17/05/2024.
//

import Foundation

enum RepositoriesToolbarType: String, CaseIterable {
    case addComponentRepo
    case refresh
    case setting

    // MARK: - Properties

    var title: String {
        switch self {
        case .addComponentRepo: "Create a component on Github"
        case .refresh: "Refresh"
        case .setting: "Setting"
        }
    }

    var description: String {
        switch self {
        case .addComponentRepo: "Create a new component repository"
        case .refresh: "Refresh the repositories"
        case .setting: "Open the settings"
        }
    }

    var systemImage: String {
        switch self {
        case .addComponentRepo: "externaldrive.badge.plus"
        case .refresh: "arrow.triangle.2.circlepath"
        case .setting: "gear"
        }
    }
}
