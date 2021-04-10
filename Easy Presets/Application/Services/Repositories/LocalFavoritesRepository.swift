//
//  LocalFavoritesRepositry.swift
//  Easy Presets
//
//  Created by ILYA Paraskevich on 20.03.21.
//

import UIKit

class LocalFavoritesRepository: FavoritesRepository {
    
    // MARK: - Types
    
    struct ObserverEntry { weak var base: FavoritesObserver? }
    
    private enum Keys {
        static var ids = "favoritesIds"
    }
    
    // MARK: - Properties
    
    private var currentFavoritesIds: [String] {
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
    
    private let presetsProvider: PresetsProvider
    
    // MARK: - Initializers
    
    init(with presets: PresetsProvider) {
        self.currentFavoritesIds = (UserDefaults.standard.array(forKey: Keys.ids) as? [String]) ?? []
        self.presetsProvider = presets
    }
    
    // MARK: - Methods
    
    private func notifyObservers() {
        notificationQueue.async { [weak self] in
            guard let self = self else { return }
            self.observers.forEach { $0.base?.repositoryUpdated(self) }
        }
    }
    
    private func filteredCategories(_ presetsCategories: [PresetsCategory]) -> [PresetsCategory]{
        var categories: [PresetsCategory] = []
        for id in currentFavoritesIds {
            presetsCategories.forEach {
                if $0.id == id { categories.append($0) }
            }
        }
        return categories
    }
    
    func getFavoritedItems(completion: @escaping ([PresetsCategory]?, Error?) -> ()) {
        presetsProvider.getPresetCategories { [weak self] presetsCategories, error in
            guard let self = self else { return }
            guard !self.currentFavoritesIds.isEmpty else {
                completion([], nil)
                return
            }
            completion(self.filteredCategories(presetsCategories!), nil)
        }
    }
    
    func addToFavorites(category: PresetsCategory) {
        storageAccessQueue.async { [weak self] in
            self?.currentFavoritesIds.append(category.id)
        }
    }
    
    func removeFromFavorites(category: PresetsCategory) {
        storageAccessQueue.async { [weak self] in
            guard let index = self?.currentFavoritesIds.firstIndex(of: category.id) else { return }
            self?.currentFavoritesIds.remove(at: index)
        }
    }
    
    func isFavorited(_ category: PresetsCategory) -> Bool {
        storageAccessQueue.sync {
            currentFavoritesIds.contains(category.id)
        }
    }
    
    func addObserver(_ observer: FavoritesObserver) {
        notificationQueue.async { [weak self] in
            guard let self = self else { return }
            guard !self.observers.contains(where: { item in item.base === observer }) else { return }
            self.observers.append(ObserverEntry(base: observer))
        }
    }
}
