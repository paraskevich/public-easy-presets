//
//  AppConfiguratorController.swift
//  Easy Presets
//
//  Created by ILYA Paraskevich on 7.02.21.
//

import UIKit

protocol AppConfiguratorDelegate: AnyObject {
    func appConfiguratorControllerDidFinish()
}

class AppConfiguratorController: UIViewController {
    
    // MARK: - Types
    
    private enum Keys {
        static var isDatabaseConfigured = "isDatabaseConfigured"
    }
    
    // MARK: - GUI
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .launchBackgroundColor
        imageView.image = UIImage(named: "launch_image")
        imageView.contentMode = .center
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    // MARK: - Properties
    
    private var isDatabaseConfigured: Bool {
        get {
            UserDefaults.standard.bool(forKey: Keys.isDatabaseConfigured)
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.isDatabaseConfigured)
        }
    }
    
    static var isConfigurationRequired: Bool {
        return !UserDefaults.standard.bool(forKey: Keys.isDatabaseConfigured)
    }
    
    weak var delegate: AppConfiguratorDelegate?
    
    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        print("AppConfiguratorController loaded")
        
        view.backgroundColor = .launchBackgroundColor
        view.addSubview(imageView)
        setConstraints()

        configureServices()
        delegate?.appConfiguratorControllerDidFinish()
    }
    
    // MARK: - Methods
    
    private func configureServices() {
        let realmPresetsProvider = RealmPresetsProvider()
        if isDatabaseConfigured == false {
            realmPresetsProvider.configure()
            isDatabaseConfigured = true
        }
        AppServicesContainer.shared = AppServicesContainer(presetsProvider: realmPresetsProvider)
    }
    
    private func setConstraints() {
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    }
}
