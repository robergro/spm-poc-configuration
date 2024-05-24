//
//  GetLocalRepositoryUseCase.swift
//  SparkConfig
//
//  Created by robin.lemaire on 16/05/2024.
//

import Foundation

final class GetLocalRepositoryUseCase {

    // MARK: - Getter

    func execute(from url: URL) -> Repository? {
        do {
            let files = try FileManager.default.contentsOfDirectory(
                at: url, 
                includingPropertiesForKeys: [.isDirectoryKey]
            )

            // Check if folder contains a .git folder
            guard files.contains(where: {
                $0.absoluteString.contains(".git")
            }) else {
                return nil
            }

            let name = url.lastPathComponent

            let type: RepositoryType = switch name {
            case _ where name.contains("theming"): .theming
            case _ where name.contains("configuration"), _ where name.contains("template"): .configuration
            case _ where name.contains("component"): .component
            case _ where name.contains("common"): .common
            default: .app
            }

            return .init(
                type: type,
                name: name,
                url: url
            )
        } catch {
            return nil
        }
    }
}
