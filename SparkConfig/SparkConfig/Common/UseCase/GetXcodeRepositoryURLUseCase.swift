//
//  GetXcodeRepositoryURLUseCase.swift
//  SparkConfig
//
//  Created by robin.lemaire on 16/05/2024.
//

import Foundation

final class GetXcodeRepositoryURLUseCase {

    // MARK: - Getter

    func execute(from repositoryURL: URL) -> URL? {
        let packagePath = repositoryURL.path + "/Package.swift"
        
        if FileManager.default.fileExists(atPath: packagePath) {
            return URL(filePath: packagePath)

        } else {
            do {
                let files = try FileManager.default.contentsOfDirectory(
                    at: repositoryURL,
                    includingPropertiesForKeys: nil
                )

                // Workspace ?
                let xcworkspaceURLs = files.filter { $0.pathExtension == "xcworkspace" }
                if let xcworkspaceURL = xcworkspaceURLs.first {
                    return xcworkspaceURL
                }

                // Project ?
                let xcodeprojURLs = files.filter { $0.pathExtension == "xcodeproj" }
                if let xcodeprojURL = xcodeprojURLs.first {
                    return xcodeprojURL
                }

                return nil

            } catch {
                return nil
            }
        }
    }
}
