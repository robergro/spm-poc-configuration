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

    // MARK: - Getter

    func execute(from repositoryURL: URL) {
        if let fileURL = self.getFileURLUseCase.execute(
            file: Constants.file,
            from: repositoryURL
        ) {
            do {
                var text = try String(
                    contentsOf: fileURL,
                    encoding: .utf8
                )

                let dependencies = text.sliceMultipleTimes(from: "dependencies", to: "]")

                // TODO: get local dependencies
                // TODO: get external dependencies



                dependencies.forEach { dependency in

                    let localDependencies = dependency.sliceMultipleTimes(from: "path: \"..", to: "\"")
                    localDependencies.forEach { localDependency in
                        print("localDependency \(localDependency)")
                    }

                    let externalDependencies = dependency.sliceMultipleTimes(from: "robergro/", to: ".git")
                    externalDependencies.forEach { externalDependency in
                        print("externalDependency \(externalDependency)")
                    }
                }


            } catch {
                Console.shared.add(error.localizedDescription, .error)
            }

        } else {
            Console.shared.add("No \(Constants.file) found !", .error)
        }
    }
}
