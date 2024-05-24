//
//  RepositoriesViewModel.swift
//  SparkConfig
//
//  Created by robin.lemaire on 16/05/2024.
//

import SwiftUI

@Observable final class RepositoriesViewModel {

    // MARK: - Properties

    @ObservationIgnored private let getLocalRepositoriesUseCase: GetLocalRepositoriesUseCase

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
        getLocalRepositoriesUseCase: GetLocalRepositoriesUseCase = .init()
    ) {
        self.getLocalRepositoriesUseCase = getLocalRepositoriesUseCase

        self.repositories = getLocalRepositoriesUseCase.execute()
    }

    // MARK: - Setter

    func refresh() {
        self.repositories = getLocalRepositoriesUseCase.execute()
    }
}
