//
//  RepositoryDetailsViewModel.swift
//  SparkConfig
//
//  Created by robin.lemaire on 16/05/2024.
//

import SwiftUI

@Observable final class RepositoryDetailsViewModel {

    // MARK: - Properties

    @ObservationIgnored private let githubURL: URL?
    @ObservationIgnored private let xcodeURL: URL?
    @ObservationIgnored private let runSourceryUseCase: RunSourceryUseCase
    @ObservationIgnored private let initComponentUseCase: InitComponentUseCase

    // MARK: - Published Properties

    let repository: Repository
    let displayName: String
    let showGithubSection: Bool
    let localRedirectionTypes: [RepositoryLocalRedirectionType]
    let executionTypes: [RepositoryExecutionType]

    // MARK: - Initialization
    
    init(
        repository: Repository,
        displayNameUseCase: GetRepositoryDisplayNameUseCase = .init(),
        getXcodeRepositoryURLUseCase: GetXcodeRepositoryURLUseCase = .init(),
        runSourceryUseCase: RunSourceryUseCase = .init(),
        initComponentUseCase: InitComponentUseCase = .init(),
        getGitRepositoryURLUseCase: GetGitRepositoryURLUseCase = .init(),
        getRepositoryDependenciesUseCase: GetRepositoryDependenciesUseCase = .init()
    ) {
        print("------")
        print("LOGROB Repo \(repository.name)")
        self.repository = repository

        self.runSourceryUseCase = runSourceryUseCase
        self.initComponentUseCase = initComponentUseCase

        getRepositoryDependenciesUseCase.execute(from: repository.url)

        self.displayName = displayNameUseCase.execute(from: repository.name)
        self.githubURL = getGitRepositoryURLUseCase.execute(from: repository.url)
        self.showGithubSection = self.githubURL != nil
        self.xcodeURL = getXcodeRepositoryURLUseCase.execute(from: repository.url)
        self.localRedirectionTypes = self.xcodeURL != nil ? RepositoryLocalRedirectionType.allCases : [.finder]
        self.executionTypes = repository.type == .component ? RepositoryExecutionType.allCases : [.runSourcery]
    }

    // MARK: - Redirection

    func redirect(from type: RepositoryExternalRedirectionType) {
        guard let githubURL = self.githubURL else {
            return
        }

        print("LOGROB github URL -\(githubURL.path)-")

        switch type {
        case .github:
            NSWorkspace.shared.open(githubURL)
        case .githubPullRequests:
            NSWorkspace.shared.open(githubURL.appending(path: "pulls"))
        }
    }

    func redirect(from type: RepositoryLocalRedirectionType) {
        switch type {
        case .xcode:
            guard let xcodeURL = self.xcodeURL else { return }
            NSWorkspace.shared.open(xcodeURL)
        case .finder:
            NSWorkspace.shared.open(self.repository.url)
        case .github:
            NSWorkspace.shared.open(self.repository.url)
        }
    }

    // MARK: - Execution

    func execute(from type: RepositoryExecutionType) {
        switch type {
        case .initComponent:
            self.initComponentUseCase.execute(
                from: self.repository
            )
        case .runSourcery:
            self.runSourceryUseCase.execute(
                from: self.repository
            )
        }
    }
}
