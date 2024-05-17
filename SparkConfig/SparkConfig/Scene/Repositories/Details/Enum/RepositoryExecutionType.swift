//
//  RepositoryExecutionType.swift
//  SparkConfig
//
//  Created by robin.lemaire on 16/05/2024.
//

enum RepositoryExecutionType: String, CaseIterable {
    case initComponent
    case runSourcery

    // MARK: - Properties

    var name: String {
        switch self {
        case .initComponent: "Init Component"
        case .runSourcery: "Run Sourcery"
        }
    }
}
