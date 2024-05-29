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

    func execute() async -> [URL] {
        let url = self.localRepositoriesLocationUseCase.getURL()
        
        do {
            return try SparkFileManager.shared.contentsOfDirectory(
                at: url,
                includingPropertiesForKeys: [.isDirectoryKey]
            )
        } catch {
            return []
        }
    }
}
