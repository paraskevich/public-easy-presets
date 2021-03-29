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
                UserDefaults.standard.set(self.currentFavoritesIds, forKey: Keys.ids)
                self.notifyObservers()
            }
        }
    }
    
    private lazy var observers: [ObserverEntry] = []
    
    private let storageAccessQueue = DispatchQueue(label: "favorites.repo.storage.access.queue")
    private let notificationQueue = DispatchQueue(label: "notification.queue")
    
    // MARK: - Methods
    
    private func notifyObservers() {
        notificationQueue.async { [weak self] in
            guard let self = self else { return }
            self.observers.forEach { $0.base?.repositoryUpdated(self) }
        }
    }
    
    func getFavoritedItems(completion: @escaping ([PresetsCategory]?, Error?) -> ()) {
        
    }
    
    func addToFavorites(category: PresetsCategory) {
        storageAccessQueue.async { [weak self] in
            self?.currentFavoritesIds.append(category.id)
        }
    }
    
    func removeFromFavorites(category: PresetsCategory) {
        
    }
    
    func isFavorited(_ category: PresetsCategory) -> Bool {
        return true
    }
    
    func addObserver(_ observer: FavoritesObserver) {
        notificationQueue.async { [weak self] in
            guard let self = self else { return }
            guard !self.observers.contains(where: { item in item.base === observer }) else { return }
            self.observers.append(ObserverEntry(base: observer))
        }
    }
}
