//
//  SwitchRepositoryDependencyLocationUseCase.swift
//  SparkConfig
//
//  Created by robin.lemaire on 16/05/2024.
//

import Foundation

final class SwitchRepositoryDependencyLocationUseCase {

    // MARK: - Execute

    func execute(from dependency: Dependency) -> Bool {
        do {
            var text = try String(
                contentsOf: dependency.packageURL,
                encoding: .utf8
            )

            let newContent = switch dependency.type {
            case .local:
                dependency.content
                    .replacingOccurrences(
                        of: "path",
                        with: "// path"
                    )
                    .replacingOccurrences(
                        of: "// url",
                        with: "url"
                    )
                    .replacingOccurrences(
                        of: "// branch",
                        with: "branch"
                    )

            case .external:
                dependency.content
                    .replacingOccurrences(
                        of: "// path",
                        with: "path"
                    )
                    .replacingOccurrences(
                        of: "url",
                        with: "// url"
                    )
                    .replacingOccurrences(
                        of: "branch",
                        with: "// branch"
                    )
            }

            text = text.replacingOccurrences(
                of: dependency.content,
                with: newContent
            )

            try text.write(
                to: dependency.packageURL,
                atomically: false,
                encoding: .utf8
            )

            Console.shared.add("The source of the \(dependency.name) dependency has changed to \(dependency.type.opposite.rawValue) !", .success)

            return true

        } catch {
            Console.shared.add(error.localizedDescription, .error)
        }

        return false
    }
}
