//
//  PresetsCategoryRealm.swift
//  Easy Presets
//
//  Created by ILYA Paraskevich on 24.01.21.
//

import RealmSwift

class PresetsCategoryRealm: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var id: String = ""
    var goodFor = List<String>()
    @objc dynamic var preview = PreviewRealm()
    var presets = List<PresetRealm>()
    
    convenience init(title: String,
                     id: String,
                     goodFor: List<String>,
                     preview: PreviewRealm,
                     presets: List<PresetRealm>) {
        self.init()
        self.title = title
        self.id = id
        self.goodFor = goodFor
        self.preview = preview
        self.presets = presets
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

extension PresetsCategory {
    init(with model: PresetsCategoryRealm) {
        self.title = model.title
        self.id = model.id
        self.goodFor = Array(model.goodFor)
        self.preview = Preview(with: model.preview)
        
        var presets: [Preset] = []
        for realmPreset in model.presets {
            let preset = Preset(with: realmPreset)
            presets.append(preset)
        }
        
        self.presets = presets
    }
}
