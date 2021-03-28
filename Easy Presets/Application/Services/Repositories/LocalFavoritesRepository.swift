//
//  LocalFavoritesRepositry.swift
//  Easy Presets
//
//  Created by ILYA Paraskevich on 20.03.21.
//

import Foundation

class LocalFavoritesRepository: FavoritesRepository {
    
    // MARK: - Types
    
    struct ObserverEntry { weak var base: FavoritesObserver? }
    
    private enum Keys {
        static var ids = "favoritesIds"
    }
    
    // MARK: - Properties
    
    private var currentFavoritesIds: [String] = [] {
        didSet {
            if oldValue != currentFavoritesIds {
                UserDefaults.standard.set(currentFavoritesIds, forKey: Keys.ids)
                self.notifyObservers()
            }
        }
    }
    
    private lazy var observers: [ObserverEntry] = []
    
    // MARK: - Methods
    
    private func notifyObservers() {
        observers.forEach { $0.base?.repositoryUpdated(self) }
    }
    
    func getFavoritedItems(completion: @escaping ([PresetsCategory]?, Error?) -> ()) {
        
    }
    
    func addToFavorites(category: PresetsCategory) {
        currentFavoritesIds.append(category.id)
    }
    
    func removeFromFavorites(category: PresetsCategory) {
        
    }
    
    func isFavorited(_ category: PresetsCategory) -> Bool {
        return true
    }
    
    func addObserver(_ observer: FavoritesObserver) {
        if observers.contains(where: { item in item.base === observer }) {
            return
        } else {
            observers.append(ObserverEntry(base: observer))
        }
    }
}
