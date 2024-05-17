//
//  RepositoriesUseCase.swift
//  SparkConfig
//
//  Created by robin.lemaire on 16/05/2024.
//

import Foundation

final class RepositoriesUseCase {

    // MARK: - Properties

    private let filesUseCase = FilesUseCase()
    private let repositoryUseCase = RepositoryUseCase()

    // MARK: - Getter

    func getRepositories() -> [Repository] {
        let files = self.filesUseCase.getAllFilesURL()

        return files.compactMap {
            self.repositoryUseCase.getRepository(from: $0)
        }.sorted{
            $0.name < $1.name
        }
    }
}
