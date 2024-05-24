//
//  AppViewModel.swift
//  SparkConfig
//
//  Created by robin.lemaire on 17/05/2024.
//

final class AppViewModel {
    
    // MARK: - Properties

    private let gitTokenUseCase: GitTokenUseCase

    // MARK: - Initialization

    init(gitTokenUseCase: GitTokenUseCase = .init()) {
        self.gitTokenUseCase = gitTokenUseCase
    }

    // MARK: - Methods

    func loadEnv() {
        self.gitTokenUseCase.setEnv()
    }
}
