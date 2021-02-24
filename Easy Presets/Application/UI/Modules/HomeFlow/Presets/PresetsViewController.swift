//
//  PresetsViewController.swift
//  Easy Presets
//
//  Created by ILYA Paraskevich on 21.01.21.
//

import UIKit

class PresetsViewController: UIViewController {
    
    // MARK: - Types
    
    private enum Constants {
        static let title: String = "Presets"
        
        enum CollectionView {
            static let itemsPerRow: CGFloat = 1
            static let insets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            static let itemsSpacing: CGFloat = 10
            static let numberOfSections: Int = 1
        }
    }
    
    // MARK: - GUI
    
    private var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect(),
                                              collectionViewLayout: UICollectionViewLayout())
        return collectionView
    }()
    
    // MARK: - Properties
    
    private lazy var appServicesContainer: AppServicesContainer = .shared
    private lazy var presetsProvider: PresetsProvider = appServicesContainer.presetsProvider
    private var presetsCategories: [PresetsCategory] = []
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("PresetsVC loaded")
        
        self.title = Constants.title
        setNavigationBarAppearance(for: self)
        
        collectionView.backgroundColor = .generalBackgroundColor
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FeedPresetCollectionCell.self, forCellWithReuseIdentifier: FeedPresetCollectionCell.cellIdentifier)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = CGRect(x: 0, y: 0,
                                      width: view.frame.width,
                                      height: view.frame.height)
    }
    
    // MARK: - Methods
    
    
    
}

// MARK: - Collection view delegate flow layout

extension PresetsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = Constants.CollectionView.insets.left + Constants.CollectionView.insets.right + Constants.CollectionView.itemsSpacing * (Constants.CollectionView.itemsPerRow - 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / Constants.CollectionView.itemsPerRow
        
        let category = presetsCategories[indexPath.row]
        let heightMultiplier = category.preview.height / category.preview.width
        let heightPerItem = widthPerItem * CGFloat(heightMultiplier)
        
        return CGSize(width: widthPerItem, height: heightPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return Constants.CollectionView.insets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.CollectionView.itemsSpacing
    }
}

//MARK: - Collection view delegate & data source

extension PresetsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Constants.CollectionView.numberOfSections
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presetsCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedPresetCollectionCell.cellIdentifier, for: indexPath) as! FeedPresetCollectionCell
        let category = presetsCategories[indexPath.row]
        let cellViewModel = FeedPresetViewModel(title: category.title,
                                                presetsCount: String(category.presets.count),
                                                previewImage: UIImage(named: category.preview.path))
        cell.configure(with: cellViewModel)
        return cell
    }
}


