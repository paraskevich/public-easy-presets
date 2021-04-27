//
//  MyCollectionViewController.swift
//  Easy Presets
//
//  Created by ILYA Paraskevich on 21.01.21.
//

import UIKit
import NVActivityIndicatorView

class MyCollectionViewController: UIViewController, FavoritesObserver {

    // MARK: - Types
    
    private enum Constants {
        static let title: String = "My Collection"
        static let loadingIndicatorHeight: CGFloat = 50
        static let loadingIndicatorWidth: CGFloat = 50
        
        enum CollectionView {
            static let itemsPerRow: CGFloat = 1
            static let insets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
            static let itemsSpacing: CGFloat = 10
            static let numberOfSections: Int = 1
        }
    }
    
    enum State: Equatable {
        case loading
        case empty
        case list([PresetsCategory])
        
        static func == (lhs: MyCollectionViewController.State, rhs: MyCollectionViewController.State) -> Bool {
            switch (lhs, rhs) {
            case (.loading, .loading):
                return true
            case (.empty, .empty):
                return true
            case (let .list(leftArray), let .list(rightArray)):
                return leftArray == rightArray
            default:
                return false
            }
        }
    }
    
    // MARK: - Properties
    
    private lazy var favoritesRepository = AppServicesContainer.shared.favoritesRepository
    private var favoritePresetsCategories: [PresetsCategory] = []
    private var state: State = .loading {
        didSet {
            switch state {
            case .loading:
                handleLoadingState()
            case .empty:
                handleEmptyState()
            case .list(let list):
                handleListState(list)
            }
        }
    }
    
    // MARK: - GUI Properties
    
    private var loadingIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: Constants.loadingIndicatorWidth, height: Constants.loadingIndicatorHeight), type: .circleStrokeSpin, color: .primaryTextColor)
    private var emptyView = AddFavoritePresetsView()
    private var collectionView = UICollectionView(frame: CGRect(),
                                                  collectionViewLayout: UICollectionViewFlowLayout())
    
    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        favoritesRepository.addObserver(self)
        setNavigationBarAppearance(for: self)
        self.title = Constants.title
        view.backgroundColor = .generalBackgroundColor
        
        addSubviews()
        getData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = CGRect(x: 0, y: 0,
                                      width: view.frame.width,
                                      height: view.frame.height)
        loadingIndicator.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
    }
    
    // MARK: - Methods
    
    private func addSubviews() {
        view.addSubview(loadingIndicator)
        loadingIndicator.isHidden = true
        
        emptyView = AddFavoritePresetsView(frame: self.view.frame)
        view.addSubview(emptyView)
        emptyView.isHidden = true
        emptyView.delegate = self
        
        view.addSubview(collectionView)
        setCollectionView()
        collectionView.isHidden = true
    }
    
    private func getData() {
        favoritesRepository.getFavoritedItems { presetsCategories, error in
            DispatchQueue.main.async {
                if let presetsCategories = presetsCategories, !presetsCategories.isEmpty {
                    self.favoritePresetsCategories = presetsCategories
                    self.state = .list(presetsCategories)
                } else {
                    self.state = .empty
                }
            }
        }
    }
    
    private func handleLoadingState() {
        loadingIndicator.isHidden = false
        collectionView.isHidden = true
        emptyView.isHidden = true
        loadingIndicator.startAnimating()
    }
    
    private func handleEmptyState() {
        loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = true
        collectionView.isHidden = true
        emptyView.isHidden = false
    }
    
    private func handleListState(_ presetsCategories: [PresetsCategory]) {
        loadingIndicator.isHidden = true
        emptyView.isHidden = true
        collectionView.isHidden = false
        collectionView.reloadData()
    }
    
    private func setCollectionView() {
        collectionView.backgroundColor = .generalBackgroundColor
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FeedPresetCollectionCell.self,
                                forCellWithReuseIdentifier: FeedPresetCollectionCell.identifier)
    }
    
    func repositoryUpdated(_ repository: FavoritesRepository) {
        DispatchQueue.main.async {
            self.getData()
        }
    }
}

// MARK: - AddFavoritePresetsViewDelegate

extension MyCollectionViewController: AddFavoritePresetsViewDelegate {
    func addPresetsButtonPressed() {
        
    }
}

// MARK: - Collection view delegate flow layout

extension MyCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = Constants.CollectionView.insets.left + Constants.CollectionView.insets.right + Constants.CollectionView.itemsSpacing * (Constants.CollectionView.itemsPerRow - 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / Constants.CollectionView.itemsPerRow
        
        let category = favoritePresetsCategories[indexPath.row]
        let heightMultiplier = CGFloat(category.preview.height) / CGFloat(category.preview.width)
        let heightPerItem = widthPerItem * heightMultiplier
        
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

extension MyCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Constants.CollectionView.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoritePresetsCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedPresetCollectionCell.identifier, for: indexPath) as! FeedPresetCollectionCell
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.masksToBounds = true
        
        let category = favoritePresetsCategories[indexPath.row]
        let cellViewModel = FeedPresetViewModel(title: category.title,
                                                presetsCount: category.presets.count,
                                                previewImage: UIImage(named: category.preview.path))
        cell.configure(with: cellViewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = favoritePresetsCategories[indexPath.row]
        let categoryViewController = CategoryViewController(with: category,
                                                            favoritesRepository: favoritesRepository)
        navigationController?.pushViewController(categoryViewController, animated: true)
    }
}
