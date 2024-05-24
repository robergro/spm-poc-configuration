//
//  RepositoryExternalRedirectionType.swift
//  SparkConfig
//
//  Created by robin.lemaire on 16/05/2024.
//

enum RepositoryExternalRedirectionType: String, CaseIterable {
    case github
    case githubPullRequests

    // MARK: - Properties

    var name: String {
        switch self {
        case .github: "Code"
        case .githubPullRequests: "Pull requests"
        }
    }
}
