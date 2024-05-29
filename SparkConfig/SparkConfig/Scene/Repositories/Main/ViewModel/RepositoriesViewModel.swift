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

    private var repositories: [Repository] = [] {
        didSet {
            Repository.sharedAll = self.repositories
        }
    }
    var searchText: String = ""
    var isLoading: Bool = true

    // MARK: - Initialization

    init(getLocalRepositoriesUseCase: GetLocalRepositoriesUseCase = .init()) {
        self.getLocalRepositoriesUseCase = getLocalRepositoriesUseCase
    }

    // MARK: - Methods

    func fetch() async {
        try? await Task.sleep(nanoseconds: 4 * 1_000_000_000) // 1 second

        self.repositories = await getLocalRepositoriesUseCase.execute()
        self.isLoading = false
    }

    // MARK: - Setter

    @MainActor
    func refresh() async {
        self.isLoading = true
        self.repositories = await self.getLocalRepositoriesUseCase.execute()
        self.isLoading = false
    }
}
