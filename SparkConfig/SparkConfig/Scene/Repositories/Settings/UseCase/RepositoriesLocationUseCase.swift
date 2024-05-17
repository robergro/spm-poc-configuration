//
//  RepositoriesLocationUseCase.swift
//  SparkConfig
//
//  Created by robin.lemaire on 15/05/2024.
//

import Foundation

final class RepositoriesLocationUseCase: DirectoryLocationUseCaseProtocol {

    // MARK: - Constants

    private enum Constants {
        static var key = "repositories.path"
        static var defaultValue = ""
    }

    // MARK: - Properties

    @DAOWrapper(
        key: Constants.key,
        defaultValue: Constants.defaultValue
    )
    private var path: String

    // MARK: - Methods

    func getURL() -> URL {
        return .init(fileURLWithPath: self.path)
    }

    func update(url: URL) {
        self.path = url.path
    }

    func reset() {
        self.path = Constants.defaultValue
    }
}
