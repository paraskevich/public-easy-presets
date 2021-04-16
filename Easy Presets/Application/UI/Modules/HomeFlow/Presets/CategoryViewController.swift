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
        static let likeImage = UIImage(named: "like")
        static let likedImage = UIImage(named: "liked")
    }
    
    // MARK: - Properties
    
    private let model: PresetsCategory
    private let favoritesRepository: FavoritesRepository
    private var header: CategoryHeaderView!
    
    private var isFavorited = false {
        didSet {
            setupRightBarButtonImage()
        }
    }
    
    // MARK: - GUI
    
    private var collectionView = UICollectionView(frame: CGRect(),
                                                  collectionViewLayout: UICollectionViewFlowLayout())
    
    // MARK: - Initializers
    
    init(with model: PresetsCategory, favoritesRepository: FavoritesRepository) {
        self.model = model
        self.favoritesRepository = favoritesRepository
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = model.title
        setNavigationBarAppearance(for: self)
        setupRightBarButtonImage()
        
        self.view.backgroundColor = .generalBackgroundColor
        
        view.addSubview(collectionView)
        setCollectionView()
        
        favoritesRepository.addObserver(self)
        isFavorited = favoritesRepository.isFavorited(model)
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
    
    private func setupRightBarButtonImage() {
        if self.isFavorited == true {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: Constants.likedImage,
                                                                     style: .plain,
                                                                     target: self,
                                                                     action: #selector(self.toggleIsFavorited))
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: Constants.likeImage,
                                                                     style: .plain,
                                                                     target: self,
                                                                     action: #selector(self.toggleIsFavorited))
        }
    }
    
    @objc private func toggleIsFavorited() {
        if isFavorited == true {
            favoritesRepository.removeFromFavorites(category: model)
            isFavorited = false
        } else {
            favoritesRepository.addToFavorites(category: model)
            isFavorited = true
        }
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
        self.header = headerView
        
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Linear interpolation for calculating the value of alpha at the current point
        var alpha = 1 - (1 / Constants.headerHeight) * scrollView.contentOffset.y
        
        if scrollView.contentOffset.y <= 0 {
            alpha = 1
        }
        
        header.didScroll(with: alpha)
    }
}

// MARK: - Extensions

extension CategoryViewController: FavoritesObserver {
    func repositoryUpdated(_ repository: FavoritesRepository) {
        DispatchQueue.main.async {
            if repository.isFavorited(self.model) == true {
                self.isFavorited = true
            } else {
                self.isFavorited = false
            }
        }
    }
}
