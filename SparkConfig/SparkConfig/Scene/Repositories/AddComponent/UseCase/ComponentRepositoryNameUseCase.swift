//
//  ComponentRepositoryNameUseCase.swift
//  SparkConfig
//
//  Created by robin.lemaire on 17/05/2024.
//

import Foundation

final class ComponentRepositoryNameUseCase {

    // MARK: - Execute

    func execute(from component: String) -> String {
        // TODO: uncomment ASAP
        // "spark-ios-component-"
        // TODO: remove ASAP
        return "spm-component-" + component
            .replacingOccurrences(of: " ", with: "-")
            .lowercased()
    }
}
