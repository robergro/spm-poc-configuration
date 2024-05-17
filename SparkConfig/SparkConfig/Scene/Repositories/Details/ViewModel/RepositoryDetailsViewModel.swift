//
//  RepositoryDetailsViewModel.swift
//  SparkConfig
//
//  Created by robin.lemaire on 16/05/2024.
//

import SwiftUI

@Observable final class RepositoryDetailsViewModel {

    // MARK: - Properties

    @ObservationIgnored private let xcodeURL: URL?
    @ObservationIgnored private let runSourceryUseCase: RepositoryRunSourceryUseCase
    @ObservationIgnored private let initComponentUseCase: InitComponentUseCase

    // MARK: - Published Properties

    let repository: Repository
    let displayName: String
    let redirectionTypes: [RepositoryRedirectionType]
    let executionTypes: [RepositoryExecutionType]

    // MARK: - Initialization
    
    init(
        repository: Repository,
        displayNameUseCase: RepositoryDisplayNameUseCase = .init(),
        repositoryXcodeURLUseCase: RepositoryXcodeURLUseCase = .init(),
        runSourceryUseCase: RepositoryRunSourceryUseCase = .init(),
        initComponentUseCase: InitComponentUseCase = .init()
    ) {
        self.repository = repository

        self.runSourceryUseCase = runSourceryUseCase
        self.initComponentUseCase = initComponentUseCase

        self.displayName = displayNameUseCase.getName(from: repository.name)
        self.xcodeURL = repositoryXcodeURLUseCase.getXcodeURL(from: repository.url)
        self.redirectionTypes = self.xcodeURL != nil ? RepositoryRedirectionType.allCases : [.finder]
        self.executionTypes = repository.type == .component ? RepositoryExecutionType.allCases : [.runSourcery]
    }

    // MARK: - Redirection

    func redirect(from type: RepositoryRedirectionType) {
        switch type {
        case .xcode:
            guard let xcodeURL = self.xcodeURL else { return }
            NSWorkspace.shared.open(xcodeURL)
        case .finder:
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
