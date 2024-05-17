//
//  RepositoriesSettingsLocationType.swift
//  SparkConfig
//
//  Created by robin.lemaire on 15/05/2024.
//

enum RepositoriesSettingsLocationType: String, CaseIterable {
    case repositories
    case derivedData

    // MARK: - Properties

    var title: String {
        switch self {
        case .repositories: "Repositories"
        case .derivedData: "Derived Data"
        }
    }

    var isLastElement: Bool {
        self == Self.allCases.last
    }
}
