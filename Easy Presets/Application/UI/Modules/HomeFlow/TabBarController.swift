//
//  TabBarController.swift
//  Easy Presets
//
//  Created by ILYA Paraskevich on 21.01.21.
//

import UIKit

class TabBarController: UITabBarController {
    
    // MARK: - Types
    
    private enum Constants {
        enum TabName {
            static var presets: String { "Presets" }
            static var myCollection: String { "My Collection" }
            static var howItWorks: String { "How It Works" }
            static var settings: String { "Settings" }
        }
        
        enum TabIcon {
            static var presets: String { "main_tab" }
            static var myCollection: String { "saved_tab" }
            static var howItWorks: String { "instruction_tab" }
            static var settings: String { "settings_tab" }
        }
    }
    
    // MARK: - Properties
    
    private let presetsNavigationController = UINavigationController(rootViewController: PresetsViewController())
    private let myCollectionNavigationController = UINavigationController(rootViewController: MyCollectionViewController())
    private let howItWorksNavigationController = UINavigationController(rootViewController: HowItWorksViewController())
    private let settingsNavigationController = UINavigationController(rootViewController: SettingsViewController())

    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabBar()
    }
    
    // MARK: - Methods
    
    private func setupTabBar() {
        presetsNavigationController.tabBarItem = UITabBarItem(title: Constants.TabName.presets,
                                                        image: UIImage(named: Constants.TabIcon.presets),
                                                        selectedImage: nil)
        myCollectionNavigationController.tabBarItem = UITabBarItem(title: Constants.TabName.myCollection,
                                                             image: UIImage(named: Constants.TabIcon.myCollection),
                                                             selectedImage: nil)
        howItWorksNavigationController.tabBarItem = UITabBarItem(title: Constants.TabName.howItWorks,
                                                           image: UIImage(named: Constants.TabIcon.howItWorks),
                                                           selectedImage: nil)
        settingsNavigationController.tabBarItem = UITabBarItem(title: Constants.TabName.settings,
                                                         image: UIImage(named: Constants.TabIcon.settings),
                                                         selectedImage: nil)
        let tabBarList = [
            presetsNavigationController,
            myCollectionNavigationController,
            howItWorksNavigationController,
            settingsNavigationController
        ]
        self.viewControllers = tabBarList
        self.tabBar.tintColor = .primaryTextColor
        self.tabBar.unselectedItemTintColor = .appGrayColor
        self.tabBar.isTranslucent = false
        self.tabBar.barTintColor = .generalBackgroundColor
    }
}
