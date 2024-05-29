//
//  RepositoryLocalRedirectionType.swift
//  SparkConfig
//
//  Created by robin.lemaire on 16/05/2024.
//

enum RepositoryLocalRedirectionType: String, CaseIterable {
    case xcode
    case finder

    // MARK: - Properties

    var description: String {
        switch self {
        case .xcode: "Open package in Xcode"
        case .finder: "Open in Finder"
        }
    }

    var systemImage: String {
        switch self {
        case .xcode: "arrow.up.forward.app"
        case .finder: "folder"
        }
    }
}
