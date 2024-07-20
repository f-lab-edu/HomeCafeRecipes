//
//  Router.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 7/9/24.
//

import UIKit

public typealias NavigationBackClosure = () -> Void

public protocol Drawable {
    var viewController: UIViewController? { get }
}

public protocol RouterProtocol {
    func push (
        _ drawable: Drawable,
        from viewController: UIViewController,
        isAnimated: Bool,
        onNavigateBack closure: NavigationBackClosure?
    )
}

class Router: NSObject, RouterProtocol {
    private var closures: [String: NavigationBackClosure] = [:]
    
    func push(
        _ drawable: Drawable,
        from viewController: UIViewController,
        isAnimated: Bool,
        onNavigateBack closure: NavigationBackClosure?
    ) {
        guard let targetViewController = drawable.viewController else {
            return
        }
        
        if let closure = closure {
            closures.updateValue(closure, forKey: targetViewController.description)
        }
        viewController.navigationController?.pushViewController(targetViewController, animated: isAnimated)
    }
    
    private func executeClosure(_ viewController: UIViewController) {
        guard let closure = closures.removeValue(forKey: viewController.description) else { return }
        closure()
    }
}

extension Router {
    func createRecipeListDependencies() -> RecipeListViewController {
        let baseNetworkService = BaseNetworkService()
        let recipeFetchService = RecipeFetchServiceImpl(networkService: baseNetworkService)
        let feedListRepository = FeedListRepositoryImpl(networkService: recipeFetchService)
        let searchFeedRepository = SearchFeedRepositoryImpl(networkService: recipeFetchService)
        let fetchFeedListUseCase = FetchFeedListUseCaseImpl(repository: feedListRepository)
        let searchFeedListUseCase = SearchFeedListUseCaseImpl(repository: searchFeedRepository)
        let recipeListInteractor = RecipeListInteractorImpl(
            fetchFeedListUseCase: fetchFeedListUseCase,
            searchFeedListUseCase: searchFeedListUseCase
        )
        let recipeListRouter = RecipeListRouterImpl(router: self)
        let recipeListVC = RecipeListViewController(
            interactor: recipeListInteractor,
            router: recipeListRouter
        )
        recipeListInteractor.delegate = recipeListVC
        return recipeListVC
    }
    
    func createAddRecipeDependencies(recipeType: RecipeType) -> AddRecipeViewController {
        let baseNetworkService = BaseNetworkService()
        let recipePostService = RecipePostServiceImpl(networkService: baseNetworkService)
        let saveRepository = AddRecipeRepositoryImpl(recipePostService: recipePostService)
        let saveRecipeUseCase = SaveRecipeUseCaseImpl(repository: saveRepository)
        let addRecipeInteractor = AddRecipeInteractorImpl(saveRecipeUseCase: saveRecipeUseCase)
        let addRecipeVC = AddRecipeViewController(recipeType: recipeType, addRecipeInteractor: addRecipeInteractor)
        return addRecipeVC
    }
    
    func createRecipeDetailDependencies(recipeID: Int) -> RecipeDetailViewController {
        let baseNetworkService = BaseNetworkService()
        let recipeDetailRepository = RecipeDetailRepositoryImpl(networkService: baseNetworkService)
        let fetchRecipeDetailUseCase = FetchRecipeDetailUseCaseImpl(repository: recipeDetailRepository)
        let detailInteractor = RecipeDetailInteractorImpl(
            fetchRecipeDetailUseCase: fetchRecipeDetailUseCase,
            recipeID: recipeID
        )
        let detailVC = RecipeDetailViewController(interactor: detailInteractor)
        detailInteractor.delegate = detailVC
        return detailVC
    }
}
