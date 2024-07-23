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
    private let recipeListMapper = RecipeListMapper()
    private let router: RecipeListRouter
    
    init(interactor: RecipeListInteractor, router: RecipeListRouter) {
        self.interactor.setDelegate(self)
        self.interactor = interactor
        self.router = router
        super.init(nibName: nil, bundle: nil)        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

// MARK: - UISearchBarDelegate

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

// MARK: - RecipeListInteractorDelegate

extension RecipeListViewController: RecipeListInteractorDelegate {
    func fetchedRecipes(result: Result<[Recipe], Error>) {
        switch result {
        case .success(let recipes):
            if !recipes.isEmpty {
                DispatchQueue.main.async {
                    self.recipeListView.setRecipes(self.recipeListMapper.mapToRecipeListItemViewModels(from: recipes))
                }
            }
        case .failure(let error):
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func showRecipeDetail(ID: Int) {
        router.navigateToRecipeDetail(from: self, recipeID: ID)
    }
}

extension RecipeListViewController: RecipeListViewDelegate {
    
    func didSelectItem(ID: Int) {
        interactor.didSelectItem(ID: ID)
    }
    
    func scrollToBottom() {
        interactor.fetchNextPage()
    }
}
