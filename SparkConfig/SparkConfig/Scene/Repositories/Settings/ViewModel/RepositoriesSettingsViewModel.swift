//
//  RepositoriesSettingsViewModel.swift
//  SparkConfig
//
//  Created by robin.lemaire on 15/05/2024.
//

import SwiftUI

@Observable final class RepositoriesSettingsViewModel {

    // MARK: - Properties

    @ObservationIgnored private let repositoriesLocationUseCase: RepositoriesLocationUseCase
    @ObservationIgnored private let derivedDataLocationUseCase: DerivedDataLocationUseCase
    @ObservationIgnored private let githubTokenUseCase: GithubTokenUseCase
    @ObservationIgnored let githubDocURL: URL?

    // MARK: - Published Properties
    
    var githubToken: String = ""
    var repositoriesLocationURL: URL
    var derivedDataLocationURL: URL

    // MARK: - Initialization

    init(
        repositoriesLocationUseCase: RepositoriesLocationUseCase = .init(),
        derivedDataLocationUseCase: DerivedDataLocationUseCase = .init(),
        githubTokenUseCase: GithubTokenUseCase = .init()
    ) {
        self.repositoriesLocationUseCase = repositoriesLocationUseCase
        self.derivedDataLocationUseCase = derivedDataLocationUseCase
        self.githubTokenUseCase = githubTokenUseCase

        self.repositoriesLocationURL = repositoriesLocationUseCase.getURL()
        self.derivedDataLocationURL = derivedDataLocationUseCase.getURL()

        self.githubToken = githubTokenUseCase.getToken()
        self.githubDocURL = URL(string: "https://cli.github.com/manual/gh_help_environment")
    }

    // MARK: - Setter

    func setRepositoriesLocationURL(_ url: URL) {
        self.repositoriesLocationUseCase.update(url: url)
        self.repositoriesLocationURL = url
    }

    func setDerivedDataLocationURL(_ url: URL) {
        self.derivedDataLocationUseCase.update(url: url)
        self.derivedDataLocationURL = url
    }

    // MARK: - Action

    func close() {
        self.githubTokenUseCase.update(token: self.githubToken)

        Console.shared.add("Hello azdpo  aopzijaz ido ")
    }

    func reset() {
        self.repositoriesLocationUseCase.reset()
        self.repositoriesLocationURL = self.repositoriesLocationUseCase.getURL()

        self.derivedDataLocationUseCase.reset()
        self.derivedDataLocationURL = self.derivedDataLocationUseCase.getURL()
    }
}
