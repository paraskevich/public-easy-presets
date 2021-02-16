//
//  PresetRealm.swift
//  Easy Presets
//
//  Created by ILYA Paraskevich on 24.01.21.
//

import RealmSwift

class PresetRealm: Object, Decodable {
    @objc dynamic var title: String = ""
    @objc dynamic var preview: PreviewRealm?
    
    enum CodingKeys: String, CodingKey {
        case title
        case preview
    }
    
    convenience init(title: String, preview: PreviewRealm) {
        self.init()
        self.title = title
        self.preview = preview
    }
    
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.title = try container.decode(String.self, forKey: .title)
        self.preview = try container.decode(PreviewRealm.self, forKey: .preview)
    }
}

class PreviewRealm: Object, Decodable {
    @objc dynamic var path: String = ""
    @objc dynamic var width: Int = 0
    @objc dynamic var height: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case path
        case width
        case height
    }
    
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
        if let previewRealm = model.preview {
            self.preview = Preview(with: previewRealm)
        } else {
            self.preview = Preview()
            assertionFailure("Preview must not be nil")
        }
    }
}
