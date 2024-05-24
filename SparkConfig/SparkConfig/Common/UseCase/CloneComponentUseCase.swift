//
//  CloneComponentUseCase.swift
//  SparkConfig
//
//  Created by robin.lemaire on 17/05/2024.
//

import Foundation

final class CloneComponentUseCase {

    // MARK: - Properties

    private let localRepositoriesLocationUseCase: LocalRepositoriesLocationUseCase

    // MARK: - Initialization

    init(localRepositoriesLocationUseCase: LocalRepositoriesLocationUseCase = .init()) {
        self.localRepositoriesLocationUseCase = localRepositoriesLocationUseCase
    }

    // MARK: - Execute

    func execute(from component: String) {
        // Clone the repository
        let repositoriesURL = self.localRepositoriesLocationUseCase.getURL()

        let result = RunCommand.shared.shellScript(
            "cd \(repositoriesURL.path) && gh repo clone \(component)"
        )

        Console.shared.add(result)
    }
}
