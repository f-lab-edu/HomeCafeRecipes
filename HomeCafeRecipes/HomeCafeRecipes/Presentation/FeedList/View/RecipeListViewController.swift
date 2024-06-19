//
//  RecipeListViewController.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 6/10/24.
//

import UIKit

class RecipeListViewController: UIViewController, RecipeListViewModelDelegate {
    
    private var viewModel: RecipeListViewModel
    private var recipes: [RecipeListItemViewModel] = []
    private let searchBar = UISearchBar()
    private let recipelistView = RecipeListView()

    init(viewModel: RecipeListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.setDelegate(self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.viewDidLoad()
    }

    private func setupUI() {
        
        view.backgroundColor = .white
        view.addSubview(searchBar)
        view.addSubview(recipelistView)

        searchBar.translatesAutoresizingMaskIntoConstraints = false
        recipelistView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -25),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor , constant: 10),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            searchBar.heightAnchor.constraint(equalToConstant: 50),

            recipelistView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            recipelistView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            recipelistView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            recipelistView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        recipelistView.collectionView.dataSource = self
        recipelistView.collectionView.delegate = self

        searchBar.delegate = self
    }

    func didFetchRecipes(_ recipes: [RecipeListItemViewModel]) {
        DispatchQueue.main.async {
            self.recipes = recipes
            self.recipelistView.collectionView.reloadData()
        }
    }

    func didFail(with error: Error) {
        print("Error: \(error.localizedDescription)")
    }
}

extension RecipeListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCell", for: indexPath) as! RecipeListViewCell
        let recipeViewModel = recipes[indexPath.item]
        cell.configure(with: recipeViewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recipeListItemViewModel = recipes[indexPath.item]        
        if let recipeItemViewModel = viewModel.didSelectItem(id: recipeListItemViewModel.id) {
            let detailVC = RecipeDetailViewController(viewModel: recipeItemViewModel)
            navigationController?.pushViewController(detailVC, animated: true)
        } else {
            let RecipeIDErrorAlert = UIAlertController(title: "오류", message: "해당 정보를 찾지 못했습니다.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                self.navigationController?.popToRootViewController(animated: true)
            }
            RecipeIDErrorAlert.addAction(okAction)
            present(RecipeIDErrorAlert, animated: true, completion: nil)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            viewModel.fetchNextPage()
        }
    }
}

extension RecipeListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            viewModel.resetSearch()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else {
            viewModel.resetSearch()
            return
        }
        viewModel.searchRecipes(with: query)
    }
            
}
