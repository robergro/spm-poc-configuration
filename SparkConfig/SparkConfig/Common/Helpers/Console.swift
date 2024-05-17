//
//  Console.swift
//  SparkConfig
//
//  Created by robin.lemaire on 17/05/2024.
//

import SwiftUI

@Observable final class Console {

    // MARK: - Properties

    @ObservationIgnored static let shared: Console = .init()

    // MARK: - Published Properties

    private(set) var logs = [Log]()

    // MARK: - Initialization

    private init() {
    }

    // MARK: - Methods

    func add(
        _ log: String,
        _ type: LogType = .none,
        _ style: LogStyle = .none
    ) {
        self.logs.append(
            .init(type: type, style: style, value: type.prefix + log)
        )
    }

    func clear() {
        self.logs.removeAll()
    }
}

// MARK: - SubModel

struct Log: Hashable {
    
    let identifier: String = UUID().uuidString
    let type: LogType
    let style: LogStyle
    let value: String

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.identifier)
    }

    static func == (lhs: Log, rhs: Log) -> Bool {
        lhs.identifier == rhs.identifier
    }
}

// MARK: - SubEnum

enum LogStyle {
    case bold
    case none

    var bold: Bool {
        return self == .bold
    }
}

enum LogType {
    case success
    case error
    case info
    case custom(Color)
    case none

    var prefix: String {
        switch self {
        case .success: "[Success] "
        case .error: "[Error] "
        case .info: "[Info] "
        case .custom, .none: ""
        }
    }

    var color: Color {
        switch self {
        case .success: .green
        case .error: .red
        case .info: .yellow
        case .custom(let color): color
        case .none: .white
        }
    }
}
