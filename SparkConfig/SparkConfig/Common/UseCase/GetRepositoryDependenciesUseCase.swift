//
//  GetRepositoryDependenciesUseCase.swift
//  SparkConfig
//
//  Created by robin.lemaire on 16/05/2024.
//

import Foundation

final class GetRepositoryDependenciesUseCase {

    // MARK: - Constants

    private enum Constants {
        static let file = "Package.swift"
    }

    // MARK: - Properties

    private let getFileURLUseCase: GetFileURLUseCase

    // MARK: - Initialization

    init(getFileURLUseCase: GetFileURLUseCase = .init()) {
        self.getFileURLUseCase = getFileURLUseCase
    }

    // MARK: - Execute

    func execute(from repositoryURL: URL) -> [Dependency] {
        if let fileURL = self.getFileURLUseCase.execute(
            file: Constants.file,
            from: repositoryURL
        ) {
            do {
                let text = try String(
                    contentsOf: fileURL,
                    encoding: .utf8
                )

                if let dependencies = text.sliceMultipleTimes(from: "dependencies", to: "]").first {
                    return dependencies.sliceMultipleTimes(from: ".package(", to: ")").compactMap {
                        let type: DependencyType = $0.contains("// url") ? .local : .external

                        guard let name = $0.sliceMultipleTimes(from: "path: \"../", to: "\"").first else {
                            return nil
                        }

                        let repository = Repository.sharedAll.first(where: {
                            $0.name.contains(name)
                        })

                        return .init(
                            type: type,
                            name: name,
                            content: $0,
                            packageURL: fileURL,
                            repository: repository
                        )
                    }
                } else {
                    Console.shared.add("No dependencies founded", .info)
                }
            } catch {
                Console.shared.add(error.localizedDescription, .error)
            }

        } else {
            Console.shared.add("No \(Constants.file) found !", .error)
        }

        return []
    }
}
