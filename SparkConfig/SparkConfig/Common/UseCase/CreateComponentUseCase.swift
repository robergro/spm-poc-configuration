//
//  CreateComponentUseCase.swift
//  SparkConfig
//
//  Created by robin.lemaire on 17/05/2024.
//

import Foundation

final class CreateComponentUseCase {

    // MARK: - Execute

    func execute(from component: String) async {
         let result = RunCommand.shared.shellScript(
            // TODO: uncomment ASAP
            // "gh repo create \(component) --public --template adevinta/spark-ios-template"
            // TODO: remove ASAP
            "gh repo create \(component) --public --template robergro/spm-poc-template"
        )

        Console.shared.add(result)
    }
}
