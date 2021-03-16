//
//  CategoryCollectionCell.swift
//  Easy Presets
//
//  Created by ILYA Paraskevich on 11.03.21.
//

import UIKit

class CategoryCollectionCell: UICollectionViewCell {
    
    // MARK: - GUI Properties
    
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .primaryTextColor
        label.textAlignment = .natural
        label.numberOfLines = 0
        label.font = UIFont.customFont(of: 24, kind: .bold)
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
    
    static let identifier: String = "categoryCollectionCellIdentifier"
    private let offset: CGFloat = 20
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(previewImageView)
        setupGradient()
        contentView.addSubview(titleLabel)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods

    func configure(with viewModel: CategoryViewModel) {
        titleLabel.text = viewModel.title
        previewImageView.image = viewModel.previewImage
    }

    private func setupGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: contentView.bounds.height * 3 / 4,
                                width: contentView.bounds.width,
                                height: contentView.bounds.height / 4)
        gradient.colors = [UIColor.clear.cgColor,
                           UIColor.generalBackgroundColor.withAlphaComponent(0.8).cgColor]
        contentView.layer.insertSublayer(gradient, at: 1)
    }
    
    private func setConstraints() {
        // previewImageView constraints
        previewImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        previewImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        previewImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        previewImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        
        // Title label constraints
        titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                           constant: -offset).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                            constant: offset).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                             constant: -offset).isActive = true
    }
}
