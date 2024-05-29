//
//  GetLocalRepositoriesUseCase.swift
//  SparkConfig
//
//  Created by robin.lemaire on 16/05/2024.
//

import Foundation

final class GetLocalRepositoriesUseCase {

    // MARK: - Properties

    private let getFoldersInLocalRepositoriesUseCase = GetFoldersInLocalRepositoriesUseCase()
    private let getLocalRepositoryUseCase = GetLocalRepositoryUseCase()

    // MARK: - Getter

    func execute() async -> [Repository] {
        let files = await self.getFoldersInLocalRepositoriesUseCase.execute()

        return files.compactMap {
            self.getLocalRepositoryUseCase.execute(from: $0)
        }.sorted{
            $0.name < $1.name
        }
    }
}
