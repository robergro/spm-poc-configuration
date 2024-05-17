//
//  CloneComponentUseCase.swift
//  SparkConfig
//
//  Created by robin.lemaire on 17/05/2024.
//

import Foundation

final class CloneComponentUseCase {

    // MARK: - Properties

    private let repositoriesLocationUseCase: RepositoriesLocationUseCase

    // MARK: - Initialization

    init(repositoriesLocationUseCase: RepositoriesLocationUseCase = .init()) {
        self.repositoriesLocationUseCase = repositoriesLocationUseCase
    }

    // MARK: - Execute

    func execute(from component: String) {
        // Clone the repository
        let repositoriesURL = self.repositoriesLocationUseCase.getURL()

        let response = RunCommand.shared.shellScript(
            "cd \(repositoriesURL.path) && gh repo clone \(component)"
        )

        Console.shared.add(response)
    }
}
