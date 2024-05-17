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
            // TODO: adding ___ before and after the word
            static let defaultName = "YOUR_COMPONENT"
            static let defaultUsername = "YOUR_NAME"
            static let defaultDate = "CURRENT_DATE"
            static let defaultYear = "CURRENT_YEAR"
        }
    }

    // MARK: - Properties

    private let repositoriesLocationUseCase: RepositoriesLocationUseCase
    private let repositoryDisplayNameUseCase: RepositoryDisplayNameUseCase

    // MARK: - Initialization

    init(
        repositoriesLocationUseCase: RepositoriesLocationUseCase = .init(),
        repositoryDisplayNameUseCase: RepositoryDisplayNameUseCase = .init()
    ) {
        self.repositoriesLocationUseCase = repositoriesLocationUseCase
        self.repositoryDisplayNameUseCase = repositoryDisplayNameUseCase
    }

    // MARK: - Execute

    func execute(from repository: Repository) {
        let componentName = self.repositoryDisplayNameUseCase.getName(from: repository.name)

        self.execute(
            repositoryPath: repository.url.path,
            componentName: componentName
        )
    }

    func execute(
        from repositoryName: String,
        componentName: String
    ) {
        // TODO: try !
        let repositoryPath = self.repositoriesLocationUseCase.getURL().path + "/" + repositoryName

        self.execute(
            repositoryPath: repositoryPath,
            componentName: componentName
        )
    }

    private func execute(
        repositoryPath: String,
        componentName: String
    ) {
        let componentName = componentName.replacingOccurrences(of: " ", with: "")

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
        self.renameContent(
            repositoryPath: repositoryPath,
            componentName: componentName
        )
        Console.shared.add("************************", .custom(.blue))
        Console.shared.add("\n\n")
    }

    // MARK: - Rename

    private func renameAll(
        forType type: PathType,
        repositoryPath: String,
        componentName: String
    ) {
        let ignorePaths = [".git", ".sourcery", ".github", ".gitignore", ".swiftlint.yml", ".DS_Store"]
        if let enumerator = FileManager.default.enumerator(atPath: repositoryPath) {
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
                try FileManager.default.moveItem(
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

    private func renameContent(
        repositoryPath: String,
        componentName: String
    ) {
        let ignorePaths = [".git", ".sourcery", ".github", ".gitignore", ".swiftlint.yml", ".DS_Store"]
        let username = NSFullUserName()
        let date = currentDate()
        let year = currentYear()

        if let enumerator = FileManager.default.enumerator(atPath: repositoryPath) {
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
