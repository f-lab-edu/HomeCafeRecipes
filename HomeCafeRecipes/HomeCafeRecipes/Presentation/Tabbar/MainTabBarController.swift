//
//  CustomTabBarController.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 6/20/24.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    private let addButton =  UIButton(type: .custom)
    private let buttonSize = CGSize(all: 64.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        setupButton()
        setupTabBar()
        setupActionButton()
    }
    
    private func setupButton() {
        addButton.backgroundColor = .blue
        addButton.setTitle("+", for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 40)
        addButton.setTitleColor(.white, for: .normal)
        addButton.layer.cornerRadius = buttonSize.width * 0.5
        addButton.layer.shadowColor = UIColor.black.cgColor
        addButton.layer.shadowOpacity = 0.3
        addButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        addButton.layer.shadowRadius = 10
    }
    
    private func setupTabBar() {
        let baseneworkServie = BaseNetworkService()
        let networkService = RecipeFetchServiceImpl(networkService: baseneworkServie)
        let repository = FeedListRepositoryImpl(networkService: networkService)
        let searchrepository = SearchFeedRepositoryImpl(networkService: networkService)
        let fetchFeedListUseCase = FetchFeedListUseCaseImpl(repository: repository)
        let searchFeedListUsecase = SearchFeedListUseCaseImpl(repository: searchrepository)
        
        let recipeListViewModel = RecipeListInteractor(fetchFeedListUseCase: fetchFeedListUseCase, searchFeedListUseCase: searchFeedListUsecase)
        
        let recipeListVC = RecipeListViewController(interactor: recipeListViewModel)
        recipeListVC.tabBarItem = UITabBarItem(title: "Recipes", image: UIImage(systemName: "list.bullet"), tag: 0)
        
        let favoritesVC = UIViewController()
        favoritesVC.view.backgroundColor = .white
        favoritesVC.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "bookmark"), tag: 1)
        
        viewControllers = [recipeListVC, favoritesVC]
    }
    
    private func setupActionButton() {
        addButton.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
        self.view.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addButton.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor),
            addButton.centerYAnchor.constraint(equalTo: tabBar.topAnchor),
            addButton.widthAnchor.constraint(equalToConstant: buttonSize.width),
            addButton.heightAnchor.constraint(equalToConstant: buttonSize.height)
        ])
    }
    
    @objc private func didTapActionButton() {
        let alert = UIAlertController(title: "게시물 작성", message: "어떤 게시물을 작성하실 건가요?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Coffee", style: .default, handler: { [weak self] _ in
            guard let self else { return }
            let addRecipeVC = AddRecipeViewController(recipeType: .coffee)
            self.navigationController?.pushViewController(addRecipeVC, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Dessert", style: .default, handler: { [weak self] _ in
            guard let self else { return }
            let addRecipeVC = AddRecipeViewController(recipeType: .dessert)
            self.navigationController?.pushViewController(addRecipeVC, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
