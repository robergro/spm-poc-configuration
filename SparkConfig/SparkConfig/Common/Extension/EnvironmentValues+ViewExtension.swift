//
//  EnvironmentValues+ViewExtension.swift
//  SparkConfig
//
//  Created by robin.lemaire on 16/05/2024.
//

import SwiftUI

struct ShowingViewKey: EnvironmentKey {
    static let defaultValue = Binding<Bool>.constant(false)
}

extension EnvironmentValues {

    var showingView: Binding<Bool> {
        get {
            return self[ShowingViewKey.self]
        }
        set {
            self[ShowingViewKey.self] = newValue
        }
    }
}
