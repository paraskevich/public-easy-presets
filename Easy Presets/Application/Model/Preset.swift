//
//  Preset.swift
//  Easy Presets
//
//  Created by ILYA Paraskevich on 24.01.21.
//

import UIKit

struct Preset {
    let title: String
    let preview: Preview
}

struct Preview {
    let path: String
    let width: Int
    let height: Int
}
