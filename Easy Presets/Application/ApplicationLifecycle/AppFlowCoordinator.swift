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
            return UserDefaults.standard.bool(forKey: Keys.onboardingSeen)
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.onboardingSeen)
        }
    }
    
    // MARK: - Initialization
    
    init(with window: UIWindow) {
        self.window = window
    }
    
    // MARK: - Methods
    
    private func requiredFlow() -> Flow {
        if onboardingSeen == false {
            return .onboarding
        } else {
            return .home
        }
    }
    
    func start() {
        if requiredFlow() == .onboarding {
            runOnboarding(in: self.window)
        } else {
            runHome(in: self.window)
        }
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

// MARK: - OnboardingDelegate

extension AppFlowCoordinator: OnboardingDelegate {
    func onboardingViewControllerDidFinish(_ controller: OnboardingViewController) {
        onboardingSeen = true
        runHome(in: window)
    }
}
