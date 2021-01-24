//
//  UIViewController+Extension.swift
//  Easy Presets
//
//  Created by ILYA Paraskevich on 23.01.21.
//

import UIKit

extension UIViewController {
    open func setNavigationBarAppearance(for viewController: UIViewController) {
        viewController.navigationController?.navigationBar.barTintColor = .generalBackgroundColor
        viewController.navigationController?.navigationBar.tintColor = .primaryTextColor
        let textAttributes = [NSAttributedString.Key.font: UIFont.customFont(of: 17, kind: .bold)]
        viewController.navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
}
