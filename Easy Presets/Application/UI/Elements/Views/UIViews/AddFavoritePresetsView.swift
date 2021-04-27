//
//  AddFavoritePresetsView.swift
//  Easy Presets
//
//  Created by ILYA Paraskevich on 20.04.21.
//

import UIKit

protocol AddFavoritePresetsViewDelegate: AnyObject {
    func addPresetsButtonPressed()
}

class AddFavoritePresetsView: UIView {
    
    // MARK: - Types
    
    private enum Constants {
        
        enum Strings {
            static var imageName: String { "empty_saved_presets" }
            static var labelText: String { "You don't have favorite presets" }
            static var buttonText: String { "Add Presets" }
        }
        
        enum UI {
            static var cornerRadius: CGFloat { 10 }
            static var offset: CGFloat { 40 }
            static var buttonOffset: CGFloat { 20 }
            static var buttonHeight: CGFloat { 50 }
            static var labelHeight: CGFloat { 30 }
        }
    }
    
    // MARK: - Properties
    
    weak var delegate: AddFavoritePresetsViewDelegate?

    // MARK: - GUI Properties
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: Constants.Strings.imageName))
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = Constants.Strings.labelText
        label.textColor = .primaryTextColor
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.customFont(of: 22, kind: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.Strings.buttonText, for: .normal)
        button.setTitleColor(.generalBackgroundColor, for: .normal)
        button.titleLabel?.font = .customFont(of: 18, kind: .semiBold)
        button.backgroundColor = .primaryButtonColor
        button.layer.cornerRadius = Constants.UI.cornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
                
        return button
    }()
    
    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imageView)
        self.addSubview(label)
        self.addSubview(button)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    @objc private func buttonPressed() {
        delegate?.addPresetsButtonPressed()
    }
    
    private func setConstraints() {
        
        // Image constraints
        imageView.topAnchor.constraint(equalTo: topAnchor,
                                       constant: Constants.UI.offset).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                           constant: Constants.UI.offset).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                            constant: -Constants.UI.offset).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        
        // Label constraints
        label.topAnchor.constraint(equalTo: imageView.bottomAnchor,
                                   constant: Constants.UI.offset).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor,
                                       constant: Constants.UI.offset).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor,
                                        constant: -Constants.UI.offset).isActive = true
        
        // Button constraints
        button.topAnchor.constraint(equalTo: label.bottomAnchor,
                                    constant: Constants.UI.offset * 2).isActive = true
        button.leadingAnchor.constraint(equalTo: leadingAnchor,
                                        constant: Constants.UI.buttonOffset).isActive = true
        button.trailingAnchor.constraint(equalTo: trailingAnchor,
                                         constant: -Constants.UI.buttonOffset).isActive = true
        button.heightAnchor.constraint(equalToConstant: Constants.UI.buttonHeight).isActive = true
    }
}
