//
//  RunCommand.swift
//  SparkConfig
//
//  Created by robin.lemaire on 16/05/2024.
//

import Foundation

// TODO: add kind of async management here

enum RunCommandError: Error {
    case unknow
}

final class RunCommand {

    // MARK: - Properties
    
    private var env = [String: String]()

    static let shared: RunCommand = .init()

    // MARK: - Initialization

    private init() {
    }

    // MARK: - Methods

    func shellScript(_ command: String) -> Result<String, Error> {
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

        do {
            var response: String?
            if let data = try pipe.fileHandleForReading.readToEnd(),
               let output = String(data: data, encoding: .utf8) {
                response = output
            }


            if let response {
                return .success(response)
            }

        } catch {
            return .failure(error)
        }

        return .failure(RunCommandError.unknow)
    }

    func setEnv(key: String, value: String) {
        env[key] = value
    }
}
