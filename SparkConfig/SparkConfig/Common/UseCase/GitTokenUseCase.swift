//
//  GitTokenUseCase.swift
//  SparkConfig
//
//  Created by robin.lemaire on 17/05/2024.
//

import Foundation

final class GitTokenUseCase {

    // MARK: - Constants

    private enum Constants {
        static var key = "GITHUB_TOKEN"
        static var defaultValue = ""
    }

    // MARK: - Properties

    @DAOWrapper(
        key: Constants.key,
        defaultValue: Constants.defaultValue
    )
    private var token: String {
        didSet {
            self.setEnv()
        }
    }

    // MARK: - Methods

    func getToken() -> String {
        return self.token
    }

    func update(token: String) {
        self.token = token
    }

    func setEnv() {
        RunCommand.shared.setEnv(
            key: Constants.key,
            value: self.token
        )
    }
}
