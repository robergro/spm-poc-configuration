//
//  InitComponentUseCase.swift
//  SparkConfig
//
//  Created by robin.lemaire on 17/05/2024.
//

import Foundation

// TODO: documentation: name of the reposition (should start with spark-ios then add the name of the component: spark-ios-component-  tag, spark-ios-component-progress-tracker, ...)

final class InitComponentUseCase {

    // MARK: - Constants

    enum Constants {
        enum Default {
            static let defaultName = "___COMPONENT_NAME___"
            static let defaultNameLowerCase = "___component_name___"
            static let defaultUsername = "___USERNAME___"
            static let defaultDate = "___CURRENT_DATE___"
            static let defaultYear = "___CURRENT_YEAR___"
        }

        enum Ignore {
            static let paths = [
                ".git",
                ".sourcery",
                ".github",
                ".gitignore",
                ".swiftlint.yml",
                ".DS_Store"
            ]
        }
    }

    // MARK: - Properties

    private let localRepositoriesLocationUseCase: LocalRepositoriesLocationUseCase
    private let getRepositoryDisplayNameUseCase: GetRepositoryDisplayNameUseCase

    // MARK: - Initialization

    init(
        localRepositoriesLocationUseCase: LocalRepositoriesLocationUseCase = .init(),
        getRepositoryDisplayNameUseCase: GetRepositoryDisplayNameUseCase = .init()
    ) {
        self.localRepositoriesLocationUseCase = localRepositoriesLocationUseCase
        self.getRepositoryDisplayNameUseCase = getRepositoryDisplayNameUseCase
    }

    // MARK: - Execute

    func execute(from repository: Repository) async {
        self.execute(
            repositoryPath: repository.url.path,
            repositoryName: repository.name
        )
    }

    func execute(from repositoryName: String) async {
        let repositoryPath = self.localRepositoriesLocationUseCase.getURL().path + "/" + repositoryName

        self.execute(
            repositoryPath: repositoryPath,
            repositoryName: repositoryName
        )
    }

    private func execute(
        repositoryPath: String,
        repositoryName: String
    ) {
        let componentName = self.getRepositoryDisplayNameUseCase.execute(from: repositoryName)
            .replacingOccurrences(of: " ", with: "")

        // Rename all folders
        Console.shared.add("************************", .custom(.blue))
        Console.shared.add("RENAME FOLDERS", .custom(.cyan), .bold)
        Console.shared.add("**", .custom(.blue))
        self.renameAll(
            forType: .folder,
            repositoryPath: repositoryPath,
            componentName: componentName
        )
        Console.shared.add("************************", .custom(.blue))
        Console.shared.add("\n\n")

        // Rename all files
        Console.shared.add("************************", .custom(.blue))
        Console.shared.add("RENAME FILES ", .custom(.cyan), .bold)
        Console.shared.add("**", .custom(.blue))
        self.renameAll(
            forType: .file,
            repositoryPath: repositoryPath,
            componentName: componentName
        )
        Console.shared.add("************************", .custom(.blue))
        Console.shared.add("\n\n")

        // Rename content files
        Console.shared.add("************************", .custom(.blue))
        Console.shared.add("RENAME CONTENT FILES ", .custom(.cyan), .bold)
        Console.shared.add("**", .custom(.blue))
        self.renameContentFile(
            repositoryPath: repositoryPath,
            componentName: componentName
        )
        Console.shared.add("************************", .custom(.blue))
        Console.shared.add("\n\n")
    }

    // MARK: - Rename Files & Folders

    //
    private func renameAll(
        forType type: PathType,
        repositoryPath: String,
        componentName: String
    ) {
        let ignorePaths = Constants.Ignore.paths
        if let enumerator = SparkFileManager.shared.enumerator(atPath: repositoryPath) {
            while let filename = enumerator.nextObject() as? String {

                if ignorePaths.contains(filename) {
                    Console.shared.add("\(type.rawValue.capitalized) to ignore : \(filename)", .info)
                } else if !filename.components(separatedBy: "/").contains(where : { ignorePaths.contains($0) }),
                          let fileType = enumerator.fileAttributes?[FileAttributeKey.type] as? FileAttributeType,
                          type.isMatching(fileType, atPath: filename) {
                    self.rename(
                        path: repositoryPath + "/" + filename,
                        type: type,
                        componentName: componentName
                    )
                }
            }
        } else {
            Console.shared.add("No files found !", .error)
        }
    }

    private func rename(
        path: String,
        type: PathType,
        componentName: String
    ) {
        if path.contains(Constants.Default.defaultName) {
            let newPath = path.replacingOccurrences(
                of: Constants.Default.defaultName,
                with: componentName
            )
            do {
                try SparkFileManager.shared.moveItem(
                    atPath: path,
                    toPath: newPath
                )
                Console.shared.add("The \(type.rawValue) at this path '\(path)' was renamed to '\(newPath)'", .success)
            } catch {
                Console.shared.add("The \(type.rawValue) at this path '\(path)' was not renamed", .error)
                Console.shared.add(error.localizedDescription, .error)
            }
        }
    }

    // MARK: - Rename Content File

    private func renameContentFile(
        repositoryPath: String,
        componentName: String
    ) {
        let ignorePaths = Constants.Ignore.paths
        let username = NSFullUserName()
        let date = currentDate()
        let year = currentYear()

        if let enumerator = SparkFileManager.shared.enumerator(atPath: repositoryPath) {
            while let filename = enumerator.nextObject() as? String {

                if ignorePaths.contains(filename) {
                    Console.shared.add("Ignore : \(filename)", .info)
                } else if !filename.components(separatedBy: "/").contains(where : { ignorePaths.contains($0) }),
                          let fileType = enumerator.fileAttributes?[FileAttributeKey.type] as? FileAttributeType,
                          fileType == .typeRegular {


                    do {
                        let pathURL = URL(filePath: repositoryPath + "/" + filename)
                        var text = try String(
                            contentsOf: pathURL,
                            encoding: .utf8
                        )

                        let replacing: [(of: String, with: String)] = [
                            (Constants.Default.defaultName, componentName),
                            (Constants.Default.defaultNameLowerCase, componentName.lowercased()),
                            (Constants.Default.defaultUsername, username),
                            (Constants.Default.defaultDate, date),
                            (Constants.Default.defaultYear, year)
                        ]

                        replacing.forEach {
                            text = text.replacingOccurrences(
                                of: $0.of,
                                with: $0.with
                            )
                        }

                        try text.write(
                            to: pathURL,
                            atomically: false,
                            encoding: .utf8
                        )

                        Console.shared.add("The \(filename) was updated", .success)
                    } catch {
                        Console.shared.add("The \(filename) was not updated \(error)", .error)
                        Console.shared.add(error.localizedDescription, .error)
                    }
                }
            }
        } else {
            Console.shared.add("No files found !", .error)
        }
    }

    // MARK: - Helpers

    private func currentDate() -> String {
        let date = Date.now
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }

    private func currentYear() -> String {
        let date = Date.now
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: date)
    }
}

// MARK: - Enum

private enum PathType: String {
    case file
    case folder

    func isMatching(_ type: FileAttributeType, atPath path: String) -> Bool {
        switch (self, type) {
        case (.file, .typeRegular), (.folder, .typeDirectory):
            return true
        default:
            return false
        }
    }
}
