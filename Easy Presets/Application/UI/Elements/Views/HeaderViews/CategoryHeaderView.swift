//
//  CategoryHeaderView.swift
//  Easy Presets
//
//  Created by ILYA Paraskevich on 11.03.21.
//

import UIKit

class CategoryHeaderView: UICollectionReusableView {
    // MARK: - Types
    
    private enum Constants {
        static let offset: CGFloat = 15
        static let labelsSpacing: CGFloat = 10
        static let numberOfLabels = 4
    }
    
    // MARK: - GUI Properties
    
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .primaryTextColor
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.customFont(of: 30, kind: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private(set) lazy var presetsCountLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(of: 16, kind: .semiBold)
        label.numberOfLines = 0
        label.textColor = .primaryTextColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private(set) lazy var goodForLabel: UILabel = {
        let label = UILabel()
        label.text = "GOOD FOR"
        label.font = .customFont(of: 14, kind: .regular)
        label.textColor = .primaryTextColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private(set) lazy var goodForListLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(of: 16, kind: .bold)
        label.numberOfLines = 3
        label.textColor = .primaryTextColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private(set) lazy var helpView: HowItWorksView = {
        let view = HowItWorksView()
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    // MARK: - Static properties
    
    static let identifier = "categoryHeaderViewIdentifier"
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .generalBackgroundColor
        self.addSubview(titleLabel)
        self.addSubview(presetsCountLabel)
        self.addSubview(goodForLabel)
        self.addSubview(goodForListLabel)
        self.addSubview(helpView)
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func configure(with model: PresetsCategory) {
        titleLabel.text = model.title
        presetsCountLabel.text = "\(model.presets.count) PRESETS"
        goodForListLabel.text = model.goodFor.joined(separator: " · ")
    }
    
    func didScroll(with alpha: CGFloat) {
        titleLabel.alpha = alpha
        presetsCountLabel.alpha = alpha
        goodForLabel.alpha = alpha
        goodForListLabel.alpha = alpha
        helpView.questionImageView.alpha = alpha
        helpView.label.alpha = alpha
        helpView.arrowImageView.alpha = alpha
    }
    
    private func setConstraints() {
        
        // Title label
        titleLabel.topAnchor.constraint(equalTo: topAnchor,
                                        constant: Constants.offset).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                            constant: Constants.offset).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                             constant: -Constants.offset).isActive = true
        
        // Presets count label
        presetsCountLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                               constant: Constants.labelsSpacing).isActive = true
        presetsCountLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                   constant: Constants.offset).isActive = true
        presetsCountLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                    constant: -Constants.offset).isActive = true
        
        // Immutable label
        goodForLabel.topAnchor.constraint(greaterThanOrEqualTo: presetsCountLabel.bottomAnchor,
                                            constant: Constants.labelsSpacing).isActive = true
        goodForLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                constant: Constants.offset).isActive = true
        goodForLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                 constant: -Constants.offset).isActive = true
        
        // Good for label
        goodForListLabel.topAnchor.constraint(equalTo: goodForLabel.bottomAnchor,
                                          constant: Constants.labelsSpacing).isActive = true
        goodForListLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                              constant: Constants.offset).isActive = true
        goodForListLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                               constant: -Constants.offset).isActive = true

        // Help view
        helpView.topAnchor.constraint(equalTo: goodForListLabel.bottomAnchor,
                                          constant: Constants.labelsSpacing * 2).isActive = true
        helpView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                              constant: Constants.offset).isActive = true
        helpView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                               constant: -Constants.offset).isActive = true
        helpView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.offset).isActive = true
    }
}
