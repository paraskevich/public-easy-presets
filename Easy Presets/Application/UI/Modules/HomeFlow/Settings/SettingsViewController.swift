//
//  SettingsViewController.swift
//  Easy Presets
//
//  Created by ILYA Paraskevich on 21.01.21.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarAppearance(for: self)
        self.title = "Settings"
        view.backgroundColor = .generalBackgroundColor
    }

}
