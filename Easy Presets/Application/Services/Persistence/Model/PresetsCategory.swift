//
//  PresetsCategory.swift
//  Easy Presets
//
//  Created by ILYA Paraskevich on 24.01.21.
//

import UIKit

struct PresetsCategory {
    let title: String
    let id: String
    let goodFor: [String]
    let preview: Preview
    let presets: [Preset]
}
