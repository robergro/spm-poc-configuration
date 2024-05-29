//
//  DependencyType.swift
//  SparkConfig
//
//  Created by robin.lemaire on 27/05/2024.
//

import Foundation

enum DependencyType: String {
    case local
    case external

    // MARK: - Properties

    var opposite: Self {
        switch self {
        case .local: .external
        case .external: .local
        }
    }

    var systemImage: String {
        switch self {
        case .local: "internaldrive"
        case .external: "externaldrive.badge.icloud"
        }
    }
}
