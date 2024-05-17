//
//  AppViewModel.swift
//  SparkConfig
//
//  Created by robin.lemaire on 17/05/2024.
//

final class AppViewModel {
    
    // MARK: - Properties

    private let githubTokenUseCase: GithubTokenUseCase

    // MARK: - Initialization

    init(githubTokenUseCase: GithubTokenUseCase = .init()) {
        self.githubTokenUseCase = githubTokenUseCase
    }

    // MARK: - Methods

    func loadEnv() {
        self.githubTokenUseCase.setEnv()
    }
}
