//
//  Entry.swift
//  SparkConfig
//
//  Created by robin.lemaire on 15/05/2024.
//

import Foundation

enum Entry: String, CaseIterable, Identifiable {
    case repositories

    // MARK: - Properties

    var id: String {
        return self.name
    }

    var name: String {
        switch self {
        case .repositories: "Repositories"
        }
    }

    var systemImage: String {
        switch self {
        case .repositories: "square.stack.3d.up"
        }
    }
}
