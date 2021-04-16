//
//  AppServicesContainer.swift
//  Easy Presets
//
//  Created by ILYA Paraskevich on 26.01.21.
//

import UIKit

class AppServicesContainer {
    static var shared: AppServicesContainer = AppServicesContainer(presetsProvider: RealmPresetsProvider(configuration: .default))
    
    let presetsProvider: PresetsProvider
    let favoritesRepository: FavoritesRepository
    
    init(presetsProvider: PresetsProvider) {
        self.presetsProvider = presetsProvider
        self.favoritesRepository = LocalFavoritesRepository(with: presetsProvider)
    }
}
