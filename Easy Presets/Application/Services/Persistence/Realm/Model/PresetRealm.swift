//
//  PresetRealm.swift
//  Easy Presets
//
//  Created by ILYA Paraskevich on 24.01.21.
//

import RealmSwift

class PresetRealm: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var preview = PreviewRealm()
    
    convenience init(title: String, preview: PreviewRealm) {
        self.init()
        self.title = title
        self.preview = preview
    }
}

class PreviewRealm: Object {
    @objc dynamic var path: String = ""
    @objc dynamic var width: Int = 0
    @objc dynamic var height: Int = 0
    
    convenience init(path: String, width: Int, height: Int) {
        self.init()
        self.path = path
        self.width = width
        self.height = height
    }
}

extension Preview {
    init(with model: PreviewRealm) {
        self.path = model.path
        self.width = model.width
        self.height = model.height
    }
}

extension Preset {
    init(with model: PresetRealm) {
        self.title = model.title
        self.preview = Preview(with: model.preview)
    }
}
