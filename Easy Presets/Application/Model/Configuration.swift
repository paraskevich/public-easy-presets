//
//  Configuration.swift
//  Easy Presets
//
//  Created by ILYA Paraskevich on 11.02.21.
//

import Foundation

struct Configuration {
    
    enum DatabaseStorageType {
        case inMemory
        case `default`
    }

    let fileName: String
    let fileExtension: String
    let bundle: Bundle
    let databaseStorage: DatabaseStorageType

    static var `default`: Configuration {
        return Configuration(fileName: "presets",
                             fileExtension: "json",
                             bundle: Bundle.main,
                             databaseStorage: .default)
    }
}
