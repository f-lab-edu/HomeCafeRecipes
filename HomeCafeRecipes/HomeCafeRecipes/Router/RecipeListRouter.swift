//
//  RecipeListRouter.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 7/9/24.
//

import UIKit

protocol RecipeListRouter {
    func navigateToRecipeDetail(from viewController: UIViewController, recipeID: Int)
}

class RecipeListRouterImpl: RecipeListRouter {
    private let router: Router
    
    init(router: Router) {
        self.router = router
    }
    
    func navigateToRecipeDetail(
        from viewController: UIViewController,
        recipeID: Int
    ) {
        let detailViewController = router.makeRecipeDetailViewController(recipeID: recipeID, router: self)
        router.push(
            detailViewController,
            from: viewController,
            isAnimated: true,
            onNavigateBack: nil)
    }
}
