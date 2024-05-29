//
//  GetGitRepositoryURLUseCase.swift
//  SparkConfig
//
//  Created by robin.lemaire on 21/05/2024.
//

import Foundation

final class GetGitRepositoryURLUseCase {

    // MARK: - Execute

    func execute(from localRepositoryURL: URL) async -> URL? {
        let result = RunCommand.shared.shellScript(
            "cd \(localRepositoryURL.path) && git ls-remote --get-url"
        )

        switch result {
        case .success(let response):
            if let repositoryPath = response.components(separatedBy: ":")
                .last?
                .replacingOccurrences(of: "\n", with: "")
                .replacingOccurrences(of: ".git", with: "") {
                return URL(string: "https://github.com/" + repositoryPath)
            }

        case .failure(let failure):
            Console.shared.add(failure.localizedDescription, .error)
            break
        }

        return nil
    }
}
