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
        static var title: String { "Presets" }
    }
    
    // MARK: - GUI
    
    private var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect(),
                                              collectionViewLayout: UICollectionViewLayout())
        return collectionView
    }()
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("PresetsVC loaded")
        
        self.title = Constants.title
        setNavigationBarAppearance(for: self)
        
        collectionView.backgroundColor = .generalBackgroundColor
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = CGRect(x: 0, y: 0,
                                      width: view.frame.width,
                                      height: view.frame.height)
    }
    
    // MARK: - Methods
    
    
    
}

//MARK: - Collection view delegate & data source

extension PresetsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        preconditionFailure()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        preconditionFailure()
    }
}

// MARK: - Collection view delegate flow layout

extension PresetsViewController: UICollectionViewDelegateFlowLayout {
    
}


