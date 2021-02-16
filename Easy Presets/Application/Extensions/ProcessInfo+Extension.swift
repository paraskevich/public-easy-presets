//
//  ProcessInfo+Extension.swift
//  Easy Presets
//
//  Created by ILYA Paraskevich on 16.02.21.
//

import Foundation

extension ProcessInfo {
    static var isTesting: Bool {
        #if DEBUG
        let isUnitTesting = ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
        guard !isUnitTesting else {
            return true
        }
        #endif
        return false
    }
}
