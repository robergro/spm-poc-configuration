//
//  RepositoryType.swift
//  SparkConfig
//
//  Created by robin.lemaire on 16/05/2024.
//

import Foundation

enum RepositoryType {
    case theming
    case configuration
    case component
    case common
    case app

    // MARK: - Properties

    var isAutoConfigurable: Bool {
        return self == .component
    }

    var systemImage: String {
        switch self {
        case .theming: "paintpalette"
        case .configuration: "wrench.and.screwdriver"
        case .component: "square.grid.2x2"
        case .common: "archivebox"
        case .app: "platter.filled.bottom.iphone"
        }
    }
}
