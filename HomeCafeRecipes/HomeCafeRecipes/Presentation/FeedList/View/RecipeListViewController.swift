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
