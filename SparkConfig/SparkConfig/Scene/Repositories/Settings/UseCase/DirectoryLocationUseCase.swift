//
//  DirectoryLocationUseCaseProtocol.swift
//  SparkConfig
//
//  Created by robin.lemaire on 15/05/2024.
//

import Foundation

protocol DirectoryLocationUseCaseProtocol {
    func getURL() -> URL
    func update(url: URL)
    func reset()
}
