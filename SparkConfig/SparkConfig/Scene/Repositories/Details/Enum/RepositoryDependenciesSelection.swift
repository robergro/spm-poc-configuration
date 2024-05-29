//
//  RepositoryDependenciesNextSelectionStatus.swift
//  SparkConfig
//
//  Created by robin.lemaire on 28/05/2024.
//

enum RepositoryDependenciesNextSelectionStatus {
    case selectedAll
    case unselectedAll

    // MARK: - Properties

    var title: String {
        switch self {
        case .selectedAll: "Select All"
        case .unselectedAll: "Unselect All"
        }
    }
}
