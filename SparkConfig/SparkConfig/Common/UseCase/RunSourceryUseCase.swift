//
//  RunSourceryUseCase.swift
//  SparkConfig
//
//  Created by robin.lemaire on 16/05/2024.
//

import Foundation

final class RunSourceryUseCase {

    // MARK: - Properties

    private let derivedDataLocationUseCase: DerivedDataLocationUseCase

    // MARK: - Initialization

    init(derivedDataLocationUseCase: DerivedDataLocationUseCase = .init()) {
        self.derivedDataLocationUseCase = derivedDataLocationUseCase
    }

    // MARK: - Execute

    func execute(from repository: Repository) {
        let path = repository.url.path

        // **
        // Project sourcery
        let response = self.runCommandLine(at: path)

        Console.shared.add("************************", .custom(.blue))
        Console.shared.add("Run project/SPM sourcery ", .custom(.cyan), .bold)
        Console.shared.add("**", .custom(.blue))
        Console.shared.add(response)
        Console.shared.add("************************", .custom(.blue))
        Console.shared.add("\n\n")
        // **

        // Dependencies sourcery
        let url = self.derivedDataLocationUseCase.getURL()

        Console.shared.add("************************", .custom(.blue))
        Console.shared.add("Run dependencies sourcery ", .custom(.cyan), .bold)

        do {
            let derivedDataFiles = try SparkFileManager.shared.contentsOfDirectory(
                at: url,
                includingPropertiesForKeys: [.isDirectoryKey]
            )

            derivedDataFiles.forEach { derivedDataFile in

                if derivedDataFile.path.contains(repository.name) {
                    Console.shared.add("Derived data founds for the \(repository.name) project", .info)

                    let dependenciesPath = derivedDataFile.path + "/SourcePackages/checkouts/"
                    do {
                        let packageFiles = try SparkFileManager.shared.contentsOfDirectory(atPath: dependenciesPath)
                        packageFiles.forEach { packageFile in
                            var isDirectory : ObjCBool = true
                            
                            _ = SparkFileManager.shared.fileExists(
                                atPath: packageFile,
                                isDirectory: &isDirectory
                            )

                            if isDirectory.boolValue {
                                let finalPath = dependenciesPath + packageFile

                                // Check if folder contains sourcery
                                if SparkFileManager.shared.fileExists(
                                    atPath: finalPath + "/.sourcery.yml"
                                ) {
                                    Console.shared.add("Run sourcery at \(finalPath)", .info)

                                    let response = self.runCommandLine(at: finalPath)
                                    Console.shared.add(response)
                                }
                            }
                        }
                    } catch {
                        Console.shared.add(error.localizedDescription, .error)
                    }
                }
            }

        } catch {
            Console.shared.add(error.localizedDescription, .error)
        }

        Console.shared.add("************************", .custom(.blue))
        Console.shared.add("\n\n")
    }

    // MARK: - Methods

    private func runCommandLine(at path: String) -> Result<String, Error> {
        RunCommand.shared.shellScript(
            "cd \(path) && sourcery"
        )
    }
}
