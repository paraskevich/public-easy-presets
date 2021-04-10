//
//  LocalFavoritesRepositoryTests.swift
//  Easy PresetsTests
//
//  Created by ILYA Paraskevich on 31.03.21.
//

import XCTest
@testable import Easy_Presets

class MockPresetsProvider: PresetsProvider {
    
    private var presetsCategories: [PresetsCategory]
    
    init(categories: [PresetsCategory]) {
        self.presetsCategories = categories
    }
    
    func getPresetCategories(_ completion: @escaping ([PresetsCategory]?, Error?) -> ()) {
        completion(presetsCategories, nil)
    }
}

class LocalFavoritesRepositoryTests: XCTestCase {
    
    // MARK: - Properties
    
    private var presetsProvider: MockPresetsProvider!
    private var sut: LocalFavoritesRepository!
    private let currentFavoritesIdsKey = "favoritesIds"
    
    // MARK: - Non-test methods
    
    private func makeMockCategory(_ id: String) -> PresetsCategory {
        return .init(title: id.uppercased(), id: id, goodFor: [], preview: Preview(), presets: [])
    }
    
    // MARK: - Tests
    
    func testGettingFavoritedItemsWhenCategoriesArrayEqualToFavorited() throws {
        
        // 1. Given
        UserDefaults.standard.setValue(["summer", "fall"], forKey: currentFavoritesIdsKey)
        
        // 2. When
        presetsProvider = MockPresetsProvider(categories: [makeMockCategory("summer"),
                                                           makeMockCategory("fall")])
        sut = LocalFavoritesRepository(with: presetsProvider)
        
        // 3. Then
        sut.getFavoritedItems { items, error in
            guard let categories = items else {
                XCTFail("No presets initialized")
                return
            }
            XCTAssertEqual(categories.count, 2)
        }
        UserDefaults.standard.removeObject(forKey: currentFavoritesIdsKey)
    }
    
    func testGettingFavoritedItemsWhenCategoriesArrayMoreThanFavorited() throws {
        // 1. Given
        UserDefaults.standard.setValue(["summer", "fall"], forKey: currentFavoritesIdsKey)
        
        // 2. When
        presetsProvider = MockPresetsProvider(categories: [makeMockCategory("summer"),
                                                           makeMockCategory("fall"),
                                                           makeMockCategory("spring"),
                                                           makeMockCategory("winter")])
        sut = LocalFavoritesRepository(with: presetsProvider)
        
        // 3. Then
        sut.getFavoritedItems { items, error in
            guard let categories = items else {
                XCTFail("No presets initialized")
                return
            }
            XCTAssertEqual(categories.count, 2)
        }
        UserDefaults.standard.removeObject(forKey: currentFavoritesIdsKey)
    }
    
    func testGettingFavoritedItemsWhenFavoritesArrayIsEmpty() throws {
        // 1. Given
        UserDefaults.standard.setValue([], forKey: currentFavoritesIdsKey)
        
        // 2. When
        presetsProvider = MockPresetsProvider(categories: [makeMockCategory("summer"),
                                                           makeMockCategory("fall"),
                                                           makeMockCategory("spring"),
                                                           makeMockCategory("winter")])
        sut = LocalFavoritesRepository(with: presetsProvider)
        
        // 3. Then
        sut.getFavoritedItems { items, error in
            guard let categories = items else {
                XCTFail("No presets initialized")
                return
            }
            XCTAssertEqual(categories.count, 0)
        }
        UserDefaults.standard.removeObject(forKey: currentFavoritesIdsKey)
    }
    
    func testIsFavorited() throws {
        // 1. Given
        UserDefaults.standard.setValue(["fall"], forKey: currentFavoritesIdsKey)
 
        // 2. When
        let trueCategory = makeMockCategory("fall")
        let falseCategory = makeMockCategory("summer")
    
        presetsProvider = MockPresetsProvider(categories: [makeMockCategory("summer"),
                                                           makeMockCategory("fall")])
        sut = LocalFavoritesRepository(with: presetsProvider)
        
        // 3. Then
        XCTAssertTrue(sut.isFavorited(trueCategory))
        XCTAssertFalse(sut.isFavorited(falseCategory))
        
        UserDefaults.standard.removeObject(forKey: currentFavoritesIdsKey)
    }
}
