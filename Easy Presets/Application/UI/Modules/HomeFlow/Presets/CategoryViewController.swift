//
//  CategoryViewController.swift
//  Easy Presets
//
//  Created by ILYA Paraskevich on 9.03.21.
//

import UIKit

class CategoryViewController: UIViewController {
    
    // MARK: - Types
    
    private enum Constants {
        static let headerHeight: CGFloat = 240
        static let itemsPerRow: CGFloat = 1
        static let insets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        static let itemsSpacing: CGFloat = 10
        static let numberOfSections: Int = 1
    }
    
    // MARK: - Properties
    
    private var model: PresetsCategory!
    
    // MARK: - GUI
    
    private var collectionView = UICollectionView(frame: CGRect(),
                                                  collectionViewLayout: UICollectionViewFlowLayout())
    
    // MARK: - Initializers
    
    init(with model: PresetsCategory) {
        super.init(nibName: nil, bundle: nil)
        self.model = model
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = model.title
        setNavigationBarAppearance(for: self)
        
        self.view.backgroundColor = .generalBackgroundColor
        view.addSubview(collectionView)
        setCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = CGRect(x: 0, y: 0,
                                      width: view.frame.width,
                                      height: view.frame.height)
    }
    
    // MARK: - Methods

    private func setCollectionView() {
        collectionView.backgroundColor = .generalBackgroundColor
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CategoryCollectionCell.self,
                                forCellWithReuseIdentifier: CategoryCollectionCell.identifier)
        collectionView.register(CategoryHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: CategoryHeaderView.identifier)
    }
}

// MARK: - Collection view delegate flow layout

extension CategoryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = Constants.insets.left + Constants.insets.right + Constants.itemsSpacing * (Constants.itemsPerRow - 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / Constants.itemsPerRow
        
        let preset = model.presets[indexPath.row]
        let heightMultiplier = CGFloat(preset.preview.height) / CGFloat(preset.preview.width)
        let heightPerItem = widthPerItem * heightMultiplier
        
        return CGSize(width: widthPerItem, height: heightPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return Constants.insets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.itemsSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height: Constants.headerHeight)
    }
}

//MARK: - Collection view delegate & data source

extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Constants.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.presets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CategoryHeaderView.identifier, for: indexPath) as! CategoryHeaderView
        headerView.configure(with: model)
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionCell.identifier, for: indexPath) as! CategoryCollectionCell
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.masksToBounds = true
        
        let preset = model.presets[indexPath.row]
        let cellViewModel = CategoryViewModel(title: preset.title,
                                              previewImage: UIImage(named: preset.preview.path))
        cell.configure(with: cellViewModel)
        
        return cell
    }
}
