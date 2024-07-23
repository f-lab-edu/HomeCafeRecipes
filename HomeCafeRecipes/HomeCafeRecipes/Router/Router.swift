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
        let recipeListInteractor = RecipeListInteractorImpl(
            fetchFeedListUseCase: FetchFeedListUseCaseImpl(
                repository: FeedListRepositoryImpl(
                    networkService: RecipeFetchServiceImpl(
                        networkService: BaseNetworkService()
                    )
                )
            ),
            searchFeedListUseCase: SearchFeedListUseCaseImpl(
                repository: SearchFeedRepositoryImpl(
                    networkService: RecipeFetchServiceImpl(
                        networkService: BaseNetworkService()
                    )
                )
            )
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
        let addRecipeInteractor = AddRecipeInteractorImpl(
            saveRecipeUseCase: AddRecipeUseCaseImpl(
                repository: AddRecipeRepositoryImpl(
                    recipePostService: RecipePostServiceImpl(
                        networkService: BaseNetworkService()
                    )
                )
            )
        )
        let addRecipeVC = AddRecipeViewController(
            recipeType: recipeType,
            addRecipeInteractor: addRecipeInteractor
        )
        addRecipeInteractor.delegate = addRecipeVC
        return addRecipeVC
    }
    
    func createRecipeDetailDependencies(recipeID: Int) -> RecipeDetailViewController {
        let detailInteractor = RecipeDetailInteractorImpl(
            fetchRecipeDetailUseCase: FetchRecipeDetailUseCaseImpl(
                repository: RecipeDetailRepositoryImpl(
                    networkService: BaseNetworkService()
                )
            ),
            recipeID: recipeID
        )
        let detailVC = RecipeDetailViewController(interactor: detailInteractor)
        detailInteractor.delegate = detailVC
        return detailVC
    }
}
