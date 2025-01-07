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
    
    func present(
        _ drawable: Drawable,
        from viewController: UIViewController,
        isAnimated: Bool,
        completion: (() -> Void)?)
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
    
    func present(
        _ drawable: Drawable,
        from viewController: UIViewController,
        isAnimated: Bool,
        completion: (() -> Void)? = nil
    ) {
        guard let targetViewController = drawable.viewController else {
            return
        }
        viewController.present(targetViewController, animated: isAnimated, completion: completion)
    }
    
    private func executeClosure(_ viewController: UIViewController) {
        guard let closure = closures.removeValue(forKey: viewController.description) else { return }
        closure()
    }
}

extension Router {
    func makeRecipeListViewController() -> RecipeListViewController {
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
    
    func makeAddRecipeViewController(recipeType: RecipeType) -> AddRecipeViewController {
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
    
    func makeRecipeDetailViewController(recipeID: Int, router: RecipeListRouter) -> RecipeDetailViewController {
        let detailInteractor = RecipeDetailInteractorImpl(
            fetchRecipeDetailUseCase: FetchRecipeDetailUseCaseImpl(
                repository: RecipeDetailRepositoryImpl(
                    networkService: BaseNetworkService()
                )
            ),
            recipeID: recipeID
        )
        
        let detailVC = RecipeDetailViewController(interactor: detailInteractor, router: router)
        detailInteractor.delegate = detailVC
        return detailVC
    }
    
    func makeCommentViewController(recipeID: Int) -> CommentViewController {
        let commentInteractor = CommentInteractorImpl(
            fetchusecase: FetchCommentUsecaseImpl(
                repository: CommentListRepositoryImpl(
                    commnetServie: CommentServiceImpl(
                        networkService: BaseNetworkService()
                    )
                )
            ),
            addusecase: AddCommentUseCaseImpl(
                addcommentRepository: AddCommenRepositoryImpl(
                    service: CommentPostServiceImpl(
                        networkService: BaseNetworkService()
                    )
                )
            )
        )
        
        let commentViewController = CommentViewController(
            commentInteractor: commentInteractor,
            recipeID: recipeID
        )
        
        commentInteractor.delegate = commentViewController
        return commentViewController
    }
    
    func makeLoginViewController() -> LoginViewController {
        let loginInteractor = LoginInteractorImpl(
            loginUseCase: LoginUseCaseImpl(
                repository: LoginRepositoryImpl(
                    loginService: LoginServiceImpl(
                        networkService: BaseNetworkService()
                    )
                )
            )
        )
        let loginRouter = LoginRouterImpl(router: self)
        let LoginViewController = LoginViewController(
            loginInteractor: loginInteractor,
            router: loginRouter
        )
        return LoginViewController
    }
    
    func makeSignUpViewController(email: String) -> SignUpViewController {
        let signUpInteractor = SignUpInteractorImpl(
            usecase: SignUpUseCaseImpl(
                repository: SignUpRepositoryImpl(
                    SignUpService: SignUpServiceImpl(
                        networkService: BaseNetworkService()
                    )
                )
            ), checkNicknameUseCase: CheckNicknameUseCaseImpl(
                repository: CheckNicknameRepositoryImpl(
                    service:CheckNicknameServiceImpl(
                        network: BaseNetworkService()
                    )
                )
            )
        )
        let loginRouter = LoginRouterImpl(router: self)
        let signUpViewcontroller = SignUpViewController(
            signUpInteractor: signUpInteractor, router: loginRouter, email: email)
        return signUpViewcontroller
    }
    
    func makeEmailVerificationViewController() -> EmailVerificationViewController {
        let emailVerificationInteractor = EmailVerificationInteractorImpl(
            sendVerificationCodeUseCase: SendVerificationCodeUseCaseImpl(
                repository: SendVerificationCodeRepositoryImpl(
                    service: SendVerificationCodeServiceImpl(
                        networkService: BaseNetworkService()
                    )
                )
            ), validateEmailCodeUseCase: ValidateEmailCodeUseCaseImpl(
                repository: ValidateEmailCodeRepositoryImpl(
                    service: EmailVerificationCodeServiceImpl(
                        network: BaseNetworkService()
                    )
                )
            )
        )
        let loginRouter = LoginRouterImpl(router: self)
        let emailVerificationViewController = EmailVerificationViewController(
            interactor: emailVerificationInteractor,
            router: loginRouter
        )
        return emailVerificationViewController
    }
}
