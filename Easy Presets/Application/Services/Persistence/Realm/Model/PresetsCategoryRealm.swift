//
//  PresetsCategoryRealm.swift
//  Easy Presets
//
//  Created by ILYA Paraskevich on 24.01.21.
//

import RealmSwift

class PresetsCategoryRealm: Object, Decodable {
    @objc dynamic var title: String = ""
    @objc dynamic var id: String = ""
    var goodFor = List<String>()
    @objc dynamic var preview: PreviewRealm?
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
    
    enum CodingKeys: String, CodingKey {
        case title
        case id
        case goodFor
        case preview
        case presets
    }
    
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.title = try container.decode(String.self, forKey: .title)
        self.id = try container.decode(String.self, forKey: .id)
        self.preview = try container.decode(PreviewRealm.self, forKey: .preview)
        
        let goodFor = try container.decode([String].self, forKey: .goodFor)
        self.goodFor.append(objectsIn: goodFor)
        
        
        let presets = try container.decode([PresetRealm].self, forKey: .presets)
        self.presets.append(objectsIn: presets)
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
        
        if let previewRealm = model.preview {
            self.preview = Preview(with: previewRealm)
        } else {
            self.preview = Preview()
            assertionFailure("Preview must not be nil")
        }
        
        var presets: [Preset] = []
        for realmPreset in model.presets {
            let preset = Preset(with: realmPreset)
            presets.append(preset)
        }
        
        self.presets = presets
    }
}
