//
//  GetFileURLUseCase.swift
//  SparkConfig
//
//  Created by robin.lemaire on 16/05/2024.
//

import Foundation

final class GetFileURLUseCase {

    // MARK: - Getter

    func execute(
        file: String,
        from repositoryURL: URL
    ) -> URL? {
        let repositoryPath = repositoryURL.path

        if let enumerator = FileManager.default.enumerator(atPath: repositoryPath) {
            while let filename = enumerator.nextObject() as? String {
                
                if filename.components(separatedBy: "/").last?.contains(file) ?? false {
                    let pathURL = URL(filePath: repositoryPath + "/" + filename)
                    return pathURL
                }
            }
        } else {
            Console.shared.add("No \(file) file found !", .error)
        }

        return nil
    }
}
