//
//  FeedPresetCollectionCell.swift
//  Easy Presets
//
//  Created by ILYA Paraskevich on 22.01.21.
//

import UIKit

class FeedPresetCollectionCell: UICollectionViewCell {
    
    // MARK: - GUI
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(of: 22, kind: .bold)
        label.textColor = .primaryTextColor
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let presetsCountLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(of: 14, kind: .semiBold)
        label.textColor = .primaryTextColor
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let previewImageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    // MARK: - Properties
    
    static let identifier: String = "FeedPresetCollectionCellIdentifier"
    private let offset: CGFloat = 20
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(previewImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(presetsCountLabel)
        setConstraints()
        setupGradient()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods

    func configure(with viewModel: FeedPresetViewModel) {
        titleLabel.text = viewModel.title
        presetsCountLabel.text = "\(viewModel.presetsCount) PRESETS"
        previewImageView.image = viewModel.previewImage
    }
    
    private func setupGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: contentView.bounds.height * 3 / 4,
                                width: contentView.bounds.width,
                                height: contentView.bounds.height / 4)
        gradient.colors = [UIColor.clear.cgColor, UIColor.generalBackgroundColor.withAlphaComponent(0.8).cgColor]
        contentView.layer.insertSublayer(gradient, at: 1)
    }
    
    private func setConstraints() {
        
        // previewImageView constraints
        previewImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        previewImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        previewImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        previewImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        
        // presetsCountLabel constraints
        presetsCountLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                  constant: -offset).isActive = true
        presetsCountLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor,
                                                constant: offset).isActive = true
        presetsCountLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor,
                                                 constant: -offset).isActive = true
        
        // titleLabel constraints
        titleLabel.bottomAnchor.constraint(equalTo: presetsCountLabel.topAnchor,
                                           constant: -offset / 4).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor,
                                         constant: offset).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor,
                                          constant: -offset).isActive = true
    }
}
