//
//  RealmPresetsProvider.swift
//  Easy Presets
//
//  Created by ILYA Paraskevich on 25.01.21.
//

import RealmSwift

enum RealmError: LocalizedError, CustomDebugStringConvertible {
    
    case noData
    case initializationError
    case fileDoesntExist(fileName: String, fileExtension: String)
    case writingDataError
    case readingFileError(underlyingError: Error)
    case parsingError(underlyingError: Error)
    
    var description: String {
        switch self {
        case .noData, .initializationError, .fileDoesntExist,
             .writingDataError, .readingFileError, .parsingError:
            return "There was a problem loading data."
        }
    }
    
    var debugDescription: String {
        switch self {
        case .noData:
            return "The results array is empty."
        case .initializationError:
            return "Couldn't initialise Realm."
        case let .fileDoesntExist(fileName, fileExtension):
            return "Could't find a file <\(fileName).\(fileExtension)>."
        case .writingDataError:
            return "Couldn't write data to database."
        case .readingFileError(let error):
            return "Couldn't read data from JSON file. Underlying error: \(error.localizedDescription)"
        case .parsingError(let error):
            return "Couldn't decode JSON file data. Underlying error: \(error.localizedDescription)"
        }
    }
}

class RealmPresetsProvider: PresetsProvider {
    
    // MARK: - Properties

    var configuration: Configuration
    
    // MARK: - Initializer

    init(configuration: Configuration) {
        self.configuration = configuration
    }

    // MARK: - Methods
    
    func initializeRealm() throws -> Realm {
        let realm: Realm
        if configuration.databaseStorage == .inMemory {
            var configuration = Realm.Configuration()
            configuration.inMemoryIdentifier = "presetsInMemoryRealm"
            realm = try Realm(configuration: configuration)
        } else {
            realm = try Realm()
        }
        return realm
    }
    
    func getPresetCategories(_ completion: @escaping ([PresetsCategory]?, Error?) -> ()) {
        let realm: Realm
        
        do {
            try realm = self.initializeRealm()
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
            completion(nil, RealmError.noData)
        } else {
            completion(results, nil)
        }
    }
    
    func configure() {
        let realm: Realm
        do {
            try realm = initializeRealm()
        } catch {
            assertionFailure(RealmError.initializationError.debugDescription)
            return 
        }
        guard let jsonData = readPresetsCategories() else { return }
        guard let presetsCategories = initJSONFile(with: jsonData) else { return }
        writePresetsCategories(presetsCategories, to: realm)
    }

    private func read(_ fileName: String, _ fileExtension: String) throws -> Data {
        let bundle = configuration.bundle
        guard let bundleURL = bundle.url(forResource: fileName, withExtension: fileExtension) else {
            throw RealmError.fileDoesntExist(fileName: fileName,
                                             fileExtension: fileExtension)
        }
        do {
            let data = try Data(contentsOf: bundleURL)
            return data
        } catch {
            throw RealmError.readingFileError(underlyingError: error)
        }
    }
    
    private func readPresetsCategories() -> Data? {
        do {
            let jsonData = try read(configuration.fileName, configuration.fileExtension)
            return jsonData
        } catch {
            assertionFailure("\(error)")
            return nil
        }
    }
    
    private func initJSONFile(with data: Data) -> [PresetsCategoryRealm]? {
        do {
            let decodedData = try JSONDecoder().decode([PresetsCategoryRealm].self, from: data)
            return decodedData
        } catch {
            if !ProcessInfo.isTesting {
                assertionFailure(error.localizedDescription)
            }
            return nil
        }
    }
    
    private func writePresetsCategories(_ presetsCategories: [PresetsCategoryRealm], to database: Realm) {
        do {
            for category in presetsCategories {
                try database.write {
                    database.add(category, update: Realm.UpdatePolicy.modified)
                }
            }
        } catch {
            assertionFailure(RealmError.writingDataError.debugDescription)
        }
    }
}
