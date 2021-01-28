//
//  PresetsProvider.swift
//  Easy Presets
//
//  Created by ILYA Paraskevich on 25.01.21.
//

import UIKit

protocol PresetsProvider {
    func getPresetCategories(_ completion: @escaping ([PresetsCategory]?, Error?) -> ())
}
