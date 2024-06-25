//
//  RecipeListViewController.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 6/10/24.
//

import UIKit

final class RecipeListViewController: UIViewController {
    
    private var interactor: RecipeListInteractor
    private var recipes: [RecipeListItemViewModel] = []
    private let searchBar = SearchBar()
    private let recipeListView = RecipeListView()

    init(interactor: RecipeListInteractor) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
        self.interactor.setDelegate(self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        recipeListView.setCollectionViewDataSourceDelegate(self)
        setupUI()
        interactor.viewDidLoad()
    }

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(searchBar)
        view.addSubview(recipeListView)

        searchBar.translatesAutoresizingMaskIntoConstraints = false
        recipeListView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            searchBar.heightAnchor.constraint(equalToConstant: 50),

            recipeListView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            recipeListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            recipeListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            recipeListView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        searchBar.setDelegate(self)
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
        if let recipeItemViewModel = interactor.didSelectItem(id: recipeListItemViewModel.id) {
            let detailVC = RecipeDetailViewController(viewModel: recipeItemViewModel)            
            navigationController?.pushViewController(detailVC, animated: true)
        } else {
            let RecipeIDErrorAlert = UIAlertController(title: "오류", message: "해당 정보를 찾지 못했습니다.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { [weak self]  _  in
                guard let self = self else { return }
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
            interactor.fetchNextPage()
        }
    }
}

extension RecipeListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isBlank {
            interactor.resetSearch()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isBlank else {
            interactor.resetSearch()
            return
        }
        interactor.searchRecipes(with: query)
    }
}

extension RecipeListViewController: RecipeListViewModelDelegate {
    
        func fetchedRecipes(_ recipes: [RecipeListItemViewModel]) {
            DispatchQueue.main.async {
                self.recipes = recipes
                self.recipeListView.reloadCollectionViewData()
            }
        }
    
        func didFail(with error: Error) {
            print("Error: \(error.localizedDescription)")
        }
}
