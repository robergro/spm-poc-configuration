//
//  GetFoldersInLocalRepositoriesUseCase.swift
//  SparkConfig
//
//  Created by robin.lemaire on 16/05/2024.
//

import Foundation

final class GetFoldersInLocalRepositoriesUseCase {

    // MARK: - Properties

    private let localRepositoriesLocationUseCase = LocalRepositoriesLocationUseCase()

    // MARK: - Getter

    func execute() -> [URL] {
        let url = self.localRepositoriesLocationUseCase.getURL()

        do {
            return try FileManager.default.contentsOfDirectory(
                at: url,
                includingPropertiesForKeys: [.isDirectoryKey]
            )
        } catch {
            return []
        }
    }
}
