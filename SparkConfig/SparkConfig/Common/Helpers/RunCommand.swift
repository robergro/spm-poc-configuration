//
//  RunCommand.swift
//  SparkConfig
//
//  Created by robin.lemaire on 16/05/2024.
//

import Foundation

final class RunCommand {

    // MARK: - Properties
    
    private var env = [String: String]()

    static let shared: RunCommand = .init()

    // MARK: - Initialization

    private init() {
    }

    // MARK: - Methods

    func shellScript(_ command: String) -> String {
        let pipe = Pipe()

        var processInfoEnv = ProcessInfo.processInfo.environment
        self.env.forEach {
            processInfoEnv[$0.key] = $0.value
        }

        let process = Process()
        process.environment = processInfoEnv
        process.standardOutput = pipe
        process.standardError = pipe
        process.arguments = ["-cl", command]
        process.launchPath = "/bin/zsh"
        process.launch()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!

        return output
    }

    func setEnv(key: String, value: String) {
        env[key] = value
    }
}
