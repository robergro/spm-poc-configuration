//
//  String+SlideExtension.swift
//  SparkConfig
//
//  Created by robin.lemaire on 24/05/2024.
//

extension String {

    func sliceMultipleTimes(from: String, to: String) -> [String] {
        self.components(separatedBy: from).dropFirst().compactMap { sub in
            (sub.range(of: to)?.lowerBound).flatMap { endRange in
                String(sub[sub.startIndex ..< endRange])
            }
        }
    }
}
