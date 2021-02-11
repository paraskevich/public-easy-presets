//
//  AppFlowCoordinator.swift
//  Easy Presets
//
//  Created by ILYA Paraskevich on 19.01.21.
//

import UIKit

class AppFlowCoordinator {
    
    // MARK: - Types
    
    private enum Flow {
        case configuration
        case onboarding
        case home
    }
    
    private enum Keys {
        static var onboardingSeen = "onboardingSeen"
    }
    
    // MARK: - Properties
    
    private var window = UIWindow()

    private var onboardingSeen: Bool {
        get {
            UserDefaults.standard.bool(forKey: Keys.onboardingSeen)
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.onboardingSeen)
        }
    }
    
    private var requiredFlow: Flow {
        if AppConfiguratorController.isConfigurationRequired == true {
            return .configuration
        } else if onboardingSeen == false {
            return .onboarding
        } else {
            return .home
        }
    }
    
    // MARK: - Initialization
    
    init(with window: UIWindow) {
        self.window = window
    }
    
    // MARK: - Methods
    
    func runRequiredFlow() {
        if requiredFlow == .configuration {
            runAppConfigurator(in: self.window)
        } else if requiredFlow == .onboarding {
            runOnboarding(in: self.window)
        } else {
            runHome(in: self.window)
        }
    }
    
    func runAppConfigurator(in window: UIWindow) {
        let appConfiguratorController = AppConfiguratorController()
        appConfiguratorController.delegate = self
        window.rootViewController = appConfiguratorController
        window.makeKeyAndVisible()
    }
    
    func runOnboarding(in window: UIWindow) {
        let onboardingViewController = OnboardingViewController()
        onboardingViewController.delegate = self
        window.rootViewController = onboardingViewController
        window.makeKeyAndVisible()
    }
    
    func runHome(in window: UIWindow) {
        let tabBarController = TabBarController()
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
}

// MARK: - Delegates

extension AppFlowCoordinator: OnboardingDelegate {
    func onboardingViewControllerDidFinish(_ controller: OnboardingViewController) {
        onboardingSeen = true
        runHome(in: window)
    }
}

extension AppFlowCoordinator: AppConfiguratorDelegate {
    func appConfiguratorControllerDidFinish() {
        runRequiredFlow()
    }
}
