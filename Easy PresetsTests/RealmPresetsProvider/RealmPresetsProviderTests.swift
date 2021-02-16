//
//  RealmPresetsProviderTests.swift
//  Easy PresetsUITests
//
//  Created by ILYA Paraskevich on 11.02.21.
//

import XCTest
@testable import Easy_Presets

class RealmPresetsProviderTests: XCTestCase {
    
    private var sut: RealmPresetsProvider!
    
    func testRealmPresetsProviderConfiguration() throws {
        let bundle = Bundle(for: RealmPresetsProviderTests.self)
        
        // 1. Given
        let configuration = Configuration(fileName: "validPresets", fileExtension: "json", bundle: bundle, databaseStorage: .inMemory)
        sut = RealmPresetsProvider(configuration: configuration)

        // 2. When
        sut.configure()

        // 3. Then
        sut.getPresetCategories { categories, error in
            guard let categories = categories else {
                XCTFail("No presets initialized")
                return
            }

            guard let firstCategory = categories.first else {
                XCTFail("Cateogries array should contain at least one category")
                return
            }

            XCTAssertEqual(firstCategory.title, "Modern")
            XCTAssertEqual(firstCategory.presets.count, 4)

            let fourthPreset = firstCategory.presets[3]
            XCTAssertEqual(fourthPreset.preview.path, "modern_4.jpg")
            XCTAssertEqual(fourthPreset.preview.width, 1300)
            XCTAssertEqual(fourthPreset.preview.height, 1625)
        }
    }
    
    func testRealmProviderConfigurationWithInvalidInput() throws {
        let bundle = Bundle(for: RealmPresetsProviderTests.self)
        
        // 1. Given
        let configuration = Configuration(fileName: "invalidPresets", fileExtension: "json", bundle: bundle, databaseStorage: .inMemory)
        sut = RealmPresetsProvider(configuration: configuration)
        
        // 2. When
        sut.configure()
        
        // 3. Then
        sut.getPresetCategories { categories, error in
            XCTAssertNotNil(error, "Input is invalid")
        }
    }
}
