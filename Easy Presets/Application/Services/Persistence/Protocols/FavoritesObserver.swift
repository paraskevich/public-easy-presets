//
//  FavoritesObserver.swift
//  Easy Presets
//
//  Created by ILYA Paraskevich on 20.03.21.
//

import Foundation

protocol FavoritesObserver: AnyObject {
    func repositoryUpdated(_ repository: FavoritesRepository)
}
