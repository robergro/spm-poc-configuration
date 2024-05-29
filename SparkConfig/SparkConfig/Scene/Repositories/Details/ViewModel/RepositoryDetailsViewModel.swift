//
//  RepositoryDetailsViewModel.swift
//  SparkConfig
//
//  Created by robin.lemaire on 16/05/2024.
//

import SwiftUI

@Observable final class RepositoryDetailsViewModel {

    // MARK: - Properties

    @ObservationIgnored private let getXcodeRepositoryURLUseCase: GetXcodeRepositoryURLUseCase
    @ObservationIgnored private let runSourceryUseCase: RunSourceryUseCase
    @ObservationIgnored private let initComponentUseCase: InitComponentUseCase
    @ObservationIgnored private let getGitRepositoryURLUseCase: GetGitRepositoryURLUseCase
    @ObservationIgnored private let getRepositoryDependenciesUseCase: GetRepositoryDependenciesUseCase
    @ObservationIgnored private let switchRepositoryDependencyLocationUseCase: SwitchRepositoryDependencyLocationUseCase

    // MARK: - Published Properties

    let repository: Repository
    var dependencies: [Dependency] = []
    var githubURL: URL?
    var showGithubSection: Bool = true
    var xcodeURL: URL?
    var selectedDependencies: [Dependency] = .init()
    var dependenciesNextSelectionStatus: RepositoryDependenciesNextSelectionStatus = .selectedAll
    let displayName: String
    var localRedirectionTypes: [RepositoryLocalRedirectionType] = RepositoryLocalRedirectionType.allCases
    let executionTypes: [RepositoryExecutionType]
    var isLoading: Bool = true
    var dependenciesIsLoading: Bool = true

    // MARK: - Initialization
    
    init(
        repository: Repository,
        displayNameUseCase: GetRepositoryDisplayNameUseCase = .init(),
        getXcodeRepositoryURLUseCase: GetXcodeRepositoryURLUseCase = .init(),
        runSourceryUseCase: RunSourceryUseCase = .init(),
        initComponentUseCase: InitComponentUseCase = .init(),
        getGitRepositoryURLUseCase: GetGitRepositoryURLUseCase = .init(),
        getRepositoryDependenciesUseCase: GetRepositoryDependenciesUseCase = .init(),
        switchRepositoryDependencyLocationUseCase: SwitchRepositoryDependencyLocationUseCase = .init()
    ) {
        self.repository = repository

        self.getXcodeRepositoryURLUseCase = getXcodeRepositoryURLUseCase
        self.runSourceryUseCase = runSourceryUseCase
        self.initComponentUseCase = initComponentUseCase
        self.getGitRepositoryURLUseCase = getGitRepositoryURLUseCase
        self.getRepositoryDependenciesUseCase = getRepositoryDependenciesUseCase
        self.switchRepositoryDependencyLocationUseCase = switchRepositoryDependencyLocationUseCase

        self.displayName = displayNameUseCase.execute(from: repository.name)
        self.executionTypes = repository.type == .component ? RepositoryExecutionType.allCases : [.runSourcery]
    }

    // MARK: - Fetch

    func fetch() async {
        self.dependencies = await self.getRepositoryDependenciesUseCase.execute(from: self.repository.url)
        self.xcodeURL = await self.getXcodeRepositoryURLUseCase.execute(from: self.repository.url)
        self.githubURL = await self.getGitRepositoryURLUseCase.execute(from: self.repository.url)

        self.showGithubSection = self.githubURL != nil
        self.localRedirectionTypes = self.xcodeURL != nil ? RepositoryLocalRedirectionType.allCases : [.finder]

        self.isLoading = false
        self.dependenciesIsLoading = false
    }

    // MARK: - Redirection

    func redirect(from type: RepositoryExternalRedirectionType) {
        guard let githubURL = self.githubURL else {
            return
        }

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
        }
    }

    // MARK: - Execution

    func execute(from type: RepositoryExecutionType) async {
        switch type {
        case .initComponent:
            await self.initComponentUseCase.execute(
                from: self.repository
            )
        case .runSourcery:
            await self.runSourceryUseCase.execute(
                from: self.repository
            )
        }
    }

    // MARK: - Dependencies

    @MainActor
    func reloadDependencies() async {
        self.dependenciesIsLoading = true

        self.dependencies = await self.getRepositoryDependenciesUseCase.execute(from: self.repository.url)
        self.dependenciesNextSelectionStatus = .selectedAll
        self.selectedDependencies.removeAll()

        self.dependenciesIsLoading = false
    }

    func selectAllDependencies() {
        switch self.dependenciesNextSelectionStatus {
        case .selectedAll: 
            self.dependenciesNextSelectionStatus = .unselectedAll
            self.selectedDependencies = self.dependencies
        case .unselectedAll:
            self.dependenciesNextSelectionStatus = .selectedAll
            self.selectedDependencies = []
        }
    }

    func setDependencyIsSelected(_ dependency: Dependency) {
        if self.dependencyIsSelected(dependency) {
            self.selectedDependencies.removeAll(where: {
                $0 == dependency
            })
        } else {
            self.selectedDependencies.append(dependency)
        }
        
        self.dependenciesNextSelectionStatus = self.dependencies == self.selectedDependencies ? .unselectedAll : .selectedAll
    }

    func dependencyIsSelected(_ dependency: Dependency) -> Bool {
        self.selectedDependencies.contains(dependency)
    }

    @MainActor
    func switchSelectionsToExternalDependencies() async {
        await self.switchDependenciesLocation(to: .external)
    }

    @MainActor
    func switchSelectionsToLocalDependencies() async {
        await self.switchDependenciesLocation(to: .local)
    }

    private func switchDependenciesLocation(to type: DependencyType) async {
        let dependencies = self.selectedDependencies.filter {
            if $0.type != type {
                return true
            } else {
                Console.shared.add("The source of the \($0.name) dependency is already on \(type.rawValue) !", .info)
                return false
            }
        }

        var succeed: Bool = false
        dependencies.forEach { dependency in
            let succeedTemp = self.switchRepositoryDependencyLocationUseCase.execute(from: dependency)
            if !succeed {
                succeed = succeedTemp
            }
        }

        // Reload only if at least one dependency changed
        if succeed {
            await self.reloadDependencies()
        }

        // Clear selected array
        self.selectedDependencies.removeAll()
        self.dependenciesNextSelectionStatus = .selectedAll
    }
}
