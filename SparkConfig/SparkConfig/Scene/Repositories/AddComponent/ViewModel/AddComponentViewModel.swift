//
//  AddComponentViewModel.swift
//  SparkConfig
//
//  Created by robin.lemaire on 15/05/2024.
//

import SwiftUI

@Observable final class AddComponentViewModel {

    // MARK: - Properties

    @ObservationIgnored private let getGitComponentRepositoryNameUseCase: GetGitComponentRepositoryNameUseCase
    @ObservationIgnored private let createComponentUseCase: CreateComponentUseCase
    @ObservationIgnored private let cloneComponentUseCase: CloneComponentUseCase
    @ObservationIgnored private let initComponentUseCase: InitComponentUseCase

    @ObservationIgnored let githubDocURL: URL?

    // MARK: - Published Properties

    var isLoading: Bool = false
    var componentName: String = ""
    var repositoryName: String {
        self.getGitComponentRepositoryNameUseCase.execute(from: self.componentName)
    }

    // MARK: - Initialization

    init(
        getGitComponentRepositoryNameUseCase: GetGitComponentRepositoryNameUseCase = .init(),
        createComponentUseCase: CreateComponentUseCase = .init(),
        cloneComponentUseCase: CloneComponentUseCase = .init(),
        initComponentUseCase: InitComponentUseCase = .init()
    ) {
        self.getGitComponentRepositoryNameUseCase = getGitComponentRepositoryNameUseCase
        self.createComponentUseCase = createComponentUseCase
        self.cloneComponentUseCase = cloneComponentUseCase
        self.initComponentUseCase = initComponentUseCase

        self.githubDocURL = URL(string: "https://github.com/cli/cli#installation")
    }

    // MARK: - Action

    @MainActor
    func createRepository() async {
        guard !self.componentName.isEmpty else {
            return
        }

        self.isLoading = true

        let repositoryName = self.repositoryName
        await self.createComponentUseCase.execute(from: repositoryName)
        sleep(3) // Need to wait before clone the project
        await self.cloneComponentUseCase.execute(from: repositoryName)
        await self.initComponentUseCase.execute(
            from: repositoryName
        )

        self.isLoading = false
    }
}
