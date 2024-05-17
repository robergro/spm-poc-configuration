//
//  Repository.swift
//  SparkConfig
//
//  Created by robin.lemaire on 16/05/2024.
//

import Foundation

struct Repository: Hashable {
    
    // MARK: - Properties

    let type: RepositoryType
    let name: String
    let url: URL

    var systemImage: String {
        self.type.systemImage
    }
}
