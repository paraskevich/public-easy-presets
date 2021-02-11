//
//  UIColor+Extension.swift
//  Easy Presets
//
//  Created by ILYA Paraskevich on 13.01.21.
//

import UIKit

extension UIColor {
    static var darkBlackColor: UIColor { requiredColor("DarkBlackColor") }
    static var generalBackgroundColor: UIColor { requiredColor("GeneralBackgroundColor") }
    static var primaryButtonColor: UIColor { requiredColor("PrimaryButtonColor") }
    static var primaryTextColor: UIColor { requiredColor("PrimaryTextColor") }
    static var appGrayColor: UIColor { requiredColor("AppGrayColor") }
    static var launchBackgroundColor: UIColor { requiredColor("LaunchBackgroundColor") }
}

// MARK: - Helper

private func requiredColor(_ name: String) -> UIColor {
    guard let color = UIColor(named: name) else {
        assertionFailure("Unknown color of name <\(name)>")
        return UIColor.black
    }
    return color
}
