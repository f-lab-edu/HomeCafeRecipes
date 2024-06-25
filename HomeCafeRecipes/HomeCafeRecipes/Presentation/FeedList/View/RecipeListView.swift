//
//  RecipeListView.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 6/10/24.
//

import UIKit

final class RecipeListView: UIView {
    
    private let itemSize = CGSize(width: UIScreen.main.bounds.width - 20, height: 200)
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .white
        addSubview(collectionView)
        collectionView.register(RecipeListViewCell.self, forCellWithReuseIdentifier: "RecipeCell")
        configureCollectionView()
    }

    private func setupLayout() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = itemSize
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        collectionView.collectionViewLayout = layout
    }
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D) {
        collectionView.dataSource = dataSourceDelegate
        collectionView.delegate = dataSourceDelegate
    }
    
    func reloadCollectionViewData() {
        collectionView.reloadData()
    }
}
