//
//  UIFont+Extension.swift
//  Easy Presets
//
//  Created by ILYA Paraskevich on 12.01.21.
//

import UIKit

extension UIFont {
    
    enum Kind: String {
        case regular = "Nunito-Regular"
        case semiBold = "Nunito-SemiBold"
        case bold = "Nunito-Bold"
    }
    
    static func customFont(of size: CGFloat, kind: Kind) -> UIFont {
        guard let font = UIFont(name: kind.rawValue, size: size) else {
            assertionFailure("Unexpected font kind.")
            return UIFont.systemFont(ofSize: size)
        }
        return font
    }
}
