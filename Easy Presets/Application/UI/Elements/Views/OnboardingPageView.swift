//
//  OnboardingPageView.swift
//  Easy Presets
//
//  Created by ILYA Paraskevich on 14.01.21.
//

import UIKit

class OnboardingPageView: UIView {
    
    // MARK: - GUI Properties

    private(set) lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private(set) lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .primaryTextColor
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.customFont(of: 24, kind: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imageView)
        self.addSubview(label)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setConstraints() {
        
        // Image constraints
        self.imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.imageView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        self.imageView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
        // Label constraints
        self.label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.label.centerYAnchor.constraint(equalTo: self.bottomAnchor, constant: -300).isActive = true
        self.label.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        self.label.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
    }
}
