//
//  AppServicesContainer.swift
//  Easy Presets
//
//  Created by ILYA Paraskevich on 26.01.21.
//

import UIKit

class AppServicesContainer {
    static var shared: AppServicesContainer = AppServicesContainer(presetsProvider: RealmPresetsProvider())
    
    let presetsProvider: PresetsProvider
    
    init(presetsProvider: PresetsProvider) {
        self.presetsProvider = presetsProvider
    }
}
