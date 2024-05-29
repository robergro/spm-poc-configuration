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
    @ObservationIgnored private let getRepositoryDependenciesUseCase: GetRepositoryDependenciesUseCase
    @ObservationIgnored private let switchRepositoryDependencyLocationUseCase: SwitchRepositoryDependencyLocationUseCase

    // MARK: - Published Properties

    let repository: Repository
    var dependencies: [Dependency]
    var selectedDependencies: [Dependency] = .init()
    var dependenciesNextSelectionStatus: RepositoryDependenciesNextSelectionStatus = .selectedAll
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
        getRepositoryDependenciesUseCase: GetRepositoryDependenciesUseCase = .init(),
        switchRepositoryDependencyLocationUseCase: SwitchRepositoryDependencyLocationUseCase = .init()
    ) {
        self.repository = repository

        self.runSourceryUseCase = runSourceryUseCase
        self.initComponentUseCase = initComponentUseCase
        self.getRepositoryDependenciesUseCase = getRepositoryDependenciesUseCase
        self.switchRepositoryDependencyLocationUseCase = switchRepositoryDependencyLocationUseCase

        self.dependencies = getRepositoryDependenciesUseCase.execute(from: repository.url)

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

    // MARK: - Dependencies

    func reloadDependencies() {
        self.dependencies = self.getRepositoryDependenciesUseCase.execute(from: self.repository.url)
        self.dependenciesNextSelectionStatus = .selectedAll
        self.selectedDependencies.removeAll()
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

    func switchSelectionsToExternalDependencies() {
        self.switchDependenciesLocation(to: .external)
    }

    func switchSelectionsToLocalDependencies() {
        self.switchDependenciesLocation(to: .local)
    }

    func switchDependenciesLocation(to type: DependencyType) {
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
            self.reloadDependencies()
        }

        // Clear selected array
        self.selectedDependencies.removeAll()
        self.dependenciesNextSelectionStatus = .selectedAll
    }
}
