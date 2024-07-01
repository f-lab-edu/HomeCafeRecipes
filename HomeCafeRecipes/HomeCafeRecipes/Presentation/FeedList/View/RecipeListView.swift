//
//  RecipeListView.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 6/10/24.
//

import UIKit

final class RecipeListView: UIView {
    
    private enum Metric {
        static let itemSize: CGSize = .init(width: UIScreen.main.bounds.width - 20, height: 200)
        static let minimumLineSpacing: CGFloat = 10.0
        static let minimumInteritemSpacing: CGFloat = 10.0
        
    }
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
        layout.itemSize = Metric.itemSize
        layout.minimumLineSpacing = Metric.minimumLineSpacing
        layout.minimumInteritemSpacing = Metric.minimumInteritemSpacing
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func setRecipes(_ recipes: [RecipeListItemViewModel]) {
        self.recipes = recipes
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension RecipeListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCell", for: indexPath) as! RecipeListViewCell
        let recipeViewModel = recipes[indexPath.item]
        cell.configure(with: recipeViewModel)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension RecipeListView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recipeListItemViewModel = recipes[indexPath.item]
        delegate?.didSelectItem(ID: recipeListItemViewModel.id)
    }
}

extension RecipeListView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            delegate?.ScrollToBottom()
        }
    }
}
