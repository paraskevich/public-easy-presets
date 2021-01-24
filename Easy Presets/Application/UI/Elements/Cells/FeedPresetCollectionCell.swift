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
        label.font = .customFont(of: 20, kind: .bold)
        label.textColor = .primaryTextColor
        label.textAlignment = .left
        return label
    }()
    
    private let presetsCountLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(of: 18, kind: .regular)
        label.textColor = .primaryTextColor
        label.textAlignment = .left
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
    
    private let offset: CGFloat = 20
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(previewImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(presetsCountLabel)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods

    private func setConstraints() {
        
        // previewImageView constraints
        previewImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        previewImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        previewImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        previewImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        
        // presetsCountLabel constraints
        presetsCountLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                  constant: offset).isActive = true
        presetsCountLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor,
                                                constant: offset).isActive = true
        presetsCountLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor,
                                                 constant: offset).isActive = true
        
        // titleLabel constraints
        titleLabel.bottomAnchor.constraint(equalTo: presetsCountLabel.topAnchor,
                                           constant: offset).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor,
                                                constant: offset).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor,
                                                 constant: offset).isActive = true
    }
    
    func configureCell(with viewModel: FeedPresetViewModel) {
        titleLabel.text = viewModel.title
        presetsCountLabel.text = viewModel.presetsCount.capitalized
        previewImageView.image = viewModel.previewImage
    }
}
