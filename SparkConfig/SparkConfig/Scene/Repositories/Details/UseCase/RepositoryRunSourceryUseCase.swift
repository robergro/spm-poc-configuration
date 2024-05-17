//
//  RepositoryRunSourceryUseCase.swift
//  SparkConfig
//
//  Created by robin.lemaire on 16/05/2024.
//

import Foundation

final class RepositoryRunSourceryUseCase {

    // MARK: - Execute

    func execute(from repository: Repository) {
        let path = repository.url.path

        let response = RunCommand.shared.shellScript(
            "cd \(path) && sourcery"
        )
        Console.shared.add(response)
    }
}
