//
//  LoginRouter.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 9/1/24.
//

import UIKit

protocol LoginRouter {
    func navigateToEmailVerification(from viewController: UIViewController)
    func navigateToSignUP(from viewController: UIViewController, email: String)
}

final class LoginRouterImpl: LoginRouter {
    private let router: Router
    
    init(router: Router) {
        self.router = router
    }
    
    func navigateToEmailVerification(from viewController: UIViewController){
        let EmailVerificationViewController = router.makeEmailVerificationViewController()
        router.push(
            EmailVerificationViewController,
            from: viewController,
            isAnimated: true,
            onNavigateBack: nil
        )
    }
    
    func navigateToSignUP(from viewController: UIViewController, email: String) {
        let SignUpViewController = router.makeSignUpViewController(email: email)
        router.push(
            SignUpViewController,
            from: viewController,
            isAnimated: true,
            onNavigateBack: nil
        )
    }
}
