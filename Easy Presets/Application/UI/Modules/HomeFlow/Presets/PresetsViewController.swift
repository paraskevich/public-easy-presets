//
//  PresetsViewController.swift
//  Easy Presets
//
//  Created by ILYA Paraskevich on 21.01.21.
//

import UIKit
import NVActivityIndicatorView

class PresetsViewController: UIViewController {
    
    // MARK: - Types
    
    private enum Constants {
        static let title: String = "Presets"
        static let loadingIndicatorHeight: CGFloat = 50
        static let loadingIndicatorWidth: CGFloat = 50
        
        enum CollectionView {
            static let itemsPerRow: CGFloat = 1
            static let insets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
            static let itemsSpacing: CGFloat = 10
            static let numberOfSections: Int = 1
        }
    }
    
    private enum State {
        case begin, loading, loaded
    }
    
    // MARK: - GUI
    private var collectionView = UICollectionView(frame: CGRect(),
                                                  collectionViewLayout: UICollectionViewFlowLayout())
    
    private var loadingIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: Constants.loadingIndicatorWidth, height: Constants.loadingIndicatorHeight), type: .circleStrokeSpin, color: .primaryTextColor)
    
    // MARK: - Properties
    
    private lazy var appServicesContainer: AppServicesContainer = .shared
    private lazy var presetsProvider: PresetsProvider = appServicesContainer.presetsProvider
    private lazy var favoritesRepository: FavoritesRepository = appServicesContainer.favoritesRepository
    private var presetsCategories: [PresetsCategory] = []
    
    private var state: State = .begin {
        didSet {
            if state == .loading {
                self.handleLoadingState()
            } else if state == .loaded {
                self.handleLoadedState()
            }
        }
    }
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = Constants.title
        self.navigationItem.backButtonTitle = " "
        setNavigationBarAppearance(for: self)
        
        view.addSubview(collectionView)
        view.addSubview(loadingIndicator)
        
        setCollectionView()
        loadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = CGRect(x: 0, y: 0,
                                      width: view.frame.width,
                                      height: view.frame.height)
        loadingIndicator.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
    }
    
    // MARK: - Methods
    
    private func handleLoadingState() {
        loadingIndicator.startAnimating()
        loadingIndicator.isHidden = false
    }
    
    private func handleLoadedState() {
        loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = true
    }
    
    private func setCollectionView() {
        collectionView.backgroundColor = .generalBackgroundColor
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FeedPresetCollectionCell.self, forCellWithReuseIdentifier: FeedPresetCollectionCell.identifier)
    }
    
    private func loadData() {
        state = .loading
        presetsProvider.getPresetCategories { [weak self] presetsCategories, error in
            guard let self = self else { return }
            if let presetsCategories = presetsCategories {
                self.presetsCategories = presetsCategories
                self.state = .loaded
                self.collectionView.reloadData()
            } else {
                let alert = UIAlertController(title: "Error",
                                              message: error.debugDescription,
                                              preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel)
                alert.addAction(action)
                self.present(alert, animated: true)
            }
        }
    }
}

// MARK: - Collection view delegate flow layout

extension PresetsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = Constants.CollectionView.insets.left + Constants.CollectionView.insets.right + Constants.CollectionView.itemsSpacing * (Constants.CollectionView.itemsPerRow - 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / Constants.CollectionView.itemsPerRow
        
        let category = presetsCategories[indexPath.row]
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

extension PresetsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Constants.CollectionView.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presetsCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedPresetCollectionCell.identifier, for: indexPath) as! FeedPresetCollectionCell
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.masksToBounds = true
        
        let category = presetsCategories[indexPath.row]
        let cellViewModel = FeedPresetViewModel(title: category.title,
                                                presetsCount: category.presets.count,
                                                previewImage: UIImage(named: category.preview.path))
        cell.configure(with: cellViewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = presetsCategories[indexPath.row]
        let categoryViewController = CategoryViewController(with: category,
                                                            favoritesRepository: favoritesRepository)
        navigationController?.pushViewController(categoryViewController, animated: true)
    }
}


