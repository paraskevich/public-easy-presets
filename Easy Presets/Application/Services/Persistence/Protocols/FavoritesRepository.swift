//
//  FavoritesRepository.swift
//  Easy Presets
//
//  Created by ILYA Paraskevich on 20.03.21.
//

import Foundation

protocol FavoritesRepository {
    func getFavoritedItems(completion: @escaping ([PresetsCategory]?, Error?) -> ())
    func addToFavorites(category: PresetsCategory)
    func removeFromFavorites(category: PresetsCategory)
    func isFavorited(_ category: PresetsCategory) -> Bool
}
