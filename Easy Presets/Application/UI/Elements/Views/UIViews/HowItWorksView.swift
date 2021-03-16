//
//  HowItWorksView.swift
//  Easy Presets
//
//  Created by ILYA Paraskevich on 12.03.21.
//

import UIKit

class HowItWorksView: UIView {
    
    // MARK: - GUI Properties

    private(set) lazy var questionImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "instruction_tab"))
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.tintColor = .primaryButtonColor
        
        return view
    }()
    
    private(set) lazy var label: UILabel = {
        let label = UILabel()
        label.text = "How it works?"
        label.textColor = .primaryTextColor
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont.customFont(of: 16, kind: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private(set) lazy var arrowImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "disclosure_arrow_right"))
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.tintColor = .primaryTextColor
        
        return view
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(questionImageView)
        self.addSubview(label)
        self.addSubview(arrowImageView)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods

    private func setConstraints() {
        // Question image view constraints
        questionImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        questionImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        questionImageView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        questionImageView.widthAnchor.constraint(equalTo: questionImageView.heightAnchor).isActive = true
        
        // Label constraints
        label.topAnchor.constraint(equalTo: topAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: questionImageView.trailingAnchor,
                                       constant: 10).isActive = true
        label.trailingAnchor.constraint(equalTo: arrowImageView.leadingAnchor,
                                        constant: -10).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        // Arrow image view constraints
        arrowImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        arrowImageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        arrowImageView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        arrowImageView.widthAnchor.constraint(equalTo: arrowImageView.heightAnchor).isActive = true
    }
}
