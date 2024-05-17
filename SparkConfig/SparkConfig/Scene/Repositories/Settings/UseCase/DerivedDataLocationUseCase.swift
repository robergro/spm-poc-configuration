//
//  DerivedDataLocationUseCase.swift
//  SparkConfig
//
//  Created by robin.lemaire on 15/05/2024.
//

import Foundation

final class DerivedDataLocationUseCase: DirectoryLocationUseCaseProtocol {

    // MARK: - Constants

    private enum Constants {
        static var key = "derivedData.path"
        static var defaultValue = "/Users/\(NSUserName())/Library/Developer/Xcode/DerivedData"
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
