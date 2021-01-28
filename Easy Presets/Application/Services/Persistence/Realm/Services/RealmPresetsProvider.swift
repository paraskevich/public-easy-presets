//
//  RealmPresetsProvider.swift
//  Easy Presets
//
//  Created by ILYA Paraskevich on 25.01.21.
//

import RealmSwift

enum RealmError: Error {
    case databaseNotInitialized
    case initializationError
    
    var errorDescription: String {
        switch self {
        case .databaseNotInitialized, .initializationError:
            return "There was a problem loading data."
        }
    }
}

class RealmPresetsProvider: PresetsProvider {
    
    func initializeRealm() throws -> Realm {
        let realm = try Realm()
        return realm
    }
    
    func getPresetCategories(_ completion: @escaping ([PresetsCategory]?, Error?) -> ()) {
        
        let realm: Realm
        
        do {
            try realm = initializeRealm()
        } catch {
            completion(nil, RealmError.initializationError)
            return
        }
        
        let realmResults = realm.objects(PresetsCategoryRealm.self)
        var results: [PresetsCategory] = []
        
        for realmResult in realmResults {
            let result = PresetsCategory(with: realmResult)
            results.append(result)
        }
        
        if results.isEmpty {
            completion(nil, RealmError.databaseNotInitialized)
        } else {
            completion(results, nil)
        }
    }
}
