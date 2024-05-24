//
//  ConsoleViewModel.swift
//  SparkConfig
//
//  Created by robin.lemaire on 17/05/2024.
//

import SwiftUI

@Observable final class ConsoleViewModel {

    // MARK: - Properties

    @ObservationIgnored var searchResults: [Log] {
        if self.searchText.isEmpty {
            return Console.shared.logs
        } else {
            return Console.shared.logs.filter {
                $0.value.lowercased().contains(self.searchText.lowercased())
            }
        }
    }

    // MARK: - Published Properties

    var searchText: String = ""
    var isConsoleVisible = true
}
