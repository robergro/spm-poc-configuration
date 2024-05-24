//
//  GetRepositoryDisplayNameUseCase.swift
//  SparkConfig
//
//  Created by robin.lemaire on 16/05/2024.
//

import Foundation

final class GetRepositoryDisplayNameUseCase {

    // MARK: - Getter

    func execute(from repositoryName: String) -> String {
        // TODO: uncomment ASAP
//        if repository.name == "spark-ios" {
        // TODO: remove ASAP
        if repositoryName == "spm-poc" {
            return "App"
        } else {
            return repositoryName
            // TODO: uncomment ASAP
    //            .replacingOccurrences(of: "spark-ios-", with: "")
    //            .replacingOccurrences(of: "component-", with: "")
            // TODO: remove ASAP
                .replacingOccurrences(of: "spm-poc-", with: "")
                .replacingOccurrences(of: "spm-component-", with: "")

                .capitalized
                .replacingOccurrences(of: "-", with: " ")
        }
    }
}
