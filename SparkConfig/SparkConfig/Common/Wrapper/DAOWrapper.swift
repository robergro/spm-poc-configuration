//
//  DAOWrapper.swift
//  SparkConfig
//
//  Created by robin.lemaire on 15/05/2024.
//

import Foundation

@propertyWrapper
class DAOWrapper<Value> {

    // MARK: - Private Properties

    private let key: String
    private let defaultValue: Value
    private let container: UserDefaults

    // MARK: - Public Properties

    public var wrappedValue: Value {
        get {
            return self.container.object(forKey: key) as? Value ?? self.defaultValue
        }
        set {
            self.container.set(newValue, forKey: key)
        }
    }

    // MARK: - Initialization

    public init(
        key: String,
        defaultValue: Value,
        container: UserDefaults = .standard
    ) {
        self.key = key
        self.defaultValue = defaultValue
        self.container = container
    }
}
