//
//  RepositoriesSettingsViewModel.swift
//  SparkConfig
//
//  Created by robin.lemaire on 15/05/2024.
//

import SwiftUI

@Observable final class RepositoriesSettingsViewModel {

    // MARK: - Properties

    @ObservationIgnored private let localRepositoriesLocationUseCase: LocalRepositoriesLocationUseCase
    @ObservationIgnored private let derivedDataLocationUseCase: DerivedDataLocationUseCase
    @ObservationIgnored private let gitTokenUseCase: GitTokenUseCase
    @ObservationIgnored let githubDocURL: URL?

    // MARK: - Published Properties
    
    var githubToken: String = ""
    var repositoriesLocationURL: URL
    var derivedDataLocationURL: URL

    // MARK: - Initialization

    init(
        localRepositoriesLocationUseCase: LocalRepositoriesLocationUseCase = .init(),
        derivedDataLocationUseCase: DerivedDataLocationUseCase = .init(),
        gitTokenUseCase: GitTokenUseCase = .init()
    ) {
        self.localRepositoriesLocationUseCase = localRepositoriesLocationUseCase
        self.derivedDataLocationUseCase = derivedDataLocationUseCase
        self.gitTokenUseCase = gitTokenUseCase

        self.repositoriesLocationURL = localRepositoriesLocationUseCase.getURL()
        self.derivedDataLocationURL = derivedDataLocationUseCase.getURL()

        self.githubToken = gitTokenUseCase.getToken()
        self.githubDocURL = URL(string: "https://cli.github.com/manual/gh_help_environment")
    }

    // MARK: - Setter

    func setRepositoriesLocationURL(_ url: URL) {
        self.localRepositoriesLocationUseCase.update(url: url)
        self.repositoriesLocationURL = url
    }

    func setDerivedDataLocationURL(_ url: URL) {
        self.derivedDataLocationUseCase.update(url: url)
        self.derivedDataLocationURL = url
    }

    // MARK: - Action

    func close() {
        self.gitTokenUseCase.update(token: self.githubToken)
    }

    func reset() {
        self.localRepositoriesLocationUseCase.reset()
        self.repositoriesLocationURL = self.localRepositoriesLocationUseCase.getURL()

        self.derivedDataLocationUseCase.reset()
        self.derivedDataLocationURL = self.derivedDataLocationUseCase.getURL()
    }
}
