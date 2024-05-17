//
//  RepositoriesViewModel.swift
//  SparkConfig
//
//  Created by robin.lemaire on 16/05/2024.
//

import SwiftUI

@Observable final class RepositoriesViewModel {

    // MARK: - Properties

    @ObservationIgnored private let repositoriesUseCase: RepositoriesUseCase

    @ObservationIgnored var searchResults: [Repository] {
        if self.searchText.isEmpty {
            return self.repositories
        } else {
            return self.repositories.filter {
                $0.name.lowercased().contains(self.searchText.lowercased())
            }
        }
    }

    // MARK: - Published Properties

    private var repositories: [Repository]
    var searchText: String = ""

    // MARK: - Initialization

    init(
        repositoriesUseCase: RepositoriesUseCase = .init()
    ) {
        self.repositoriesUseCase = repositoriesUseCase

        self.repositories = repositoriesUseCase.getRepositories()
    }

    // MARK: - Setter

    func refresh() {
        self.repositories = repositoriesUseCase.getRepositories()
    }
}
