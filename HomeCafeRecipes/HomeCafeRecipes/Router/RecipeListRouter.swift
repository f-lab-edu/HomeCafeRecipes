//
//  RecipeListRouter.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 7/9/24.
//

import UIKit

protocol RecipeListRouter {
    func navigateToRecipeDetail(from viewController: UIViewController, recipeID: Int)
    func presentCommentViewModally(from viewController: UIViewController, recipeID: Int)
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
    
    func presentCommentViewModally(
        from viewController: UIViewController,
        recipeID: Int
    ) {
        let commentViewController = router.makeCommentViewController(recipeID: recipeID)
        
        commentViewController.modalPresentationStyle = .pageSheet
        if let sheet = commentViewController.sheetPresentationController {
            let customDetent = UISheetPresentationController.Detent.custom { context in
                return context.maximumDetentValue * 0.6
            }
            sheet.detents = [customDetent]
        }
        
        router.present(
            commentViewController,
            from: viewController,
            isAnimated: true
        )
    }
}
