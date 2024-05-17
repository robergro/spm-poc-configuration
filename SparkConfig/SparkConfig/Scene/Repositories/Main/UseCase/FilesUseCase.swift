//
//  FilesUseCase.swift
//  SparkConfig
//
//  Created by robin.lemaire on 16/05/2024.
//

import Foundation

final class FilesUseCase {

    // MARK: - Properties

    private let repositoriesLocationUseCase = RepositoriesLocationUseCase()

    // MARK: - Getter

    func getAllFilesURL() -> [URL] {
        let url = self.repositoriesLocationUseCase.getURL()

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
