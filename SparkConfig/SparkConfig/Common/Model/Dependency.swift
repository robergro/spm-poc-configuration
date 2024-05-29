//
//  Dependency.swift
//  SparkConfig
//
//  Created by robin.lemaire on 16/05/2024.
//

import Foundation

struct Dependency: Hashable, Identifiable {

    // MARK: - Properties

    let id = UUID()
    let type: DependencyType
    let name: String
    let content: String
    let packageURL: URL
    let repository: Repository?

    var systemImage: String {
        self.type.systemImage
    }
}
