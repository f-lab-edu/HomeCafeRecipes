//
//  LoginInteractor.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 8/28/24.
//

import UIKit

import RxSwift

protocol LoginViewControllerDelegate: AnyObject {
    func loadUser(viewModel: LoginViewModel)
}

protocol LoginInteractor: AnyObject {
    func login(userID: String, password: String) -> Single<Result<Bool, LoginError>>
    func loadUser()
    func didEndEditing(ID: String)
    func didEndEditing(password: String)
}

final class LoginInteractorImpl: LoginInteractor {
    private var userID: String = ""
    private var password: String = ""
    
    weak var delegate: LoginViewControllerDelegate?
    
    private let loginUseCase: LoginUseCase
    private let tokenSaveUseCase: TokenSaveUseCase
    
    init(loginUseCase: LoginUseCase, tokensaveUsecase: TokenSaveUseCase) {
        self.loginUseCase = loginUseCase
        self.tokenSaveUseCase = tokensaveUsecase
    }
    
    func login(userID: String, password: String) -> Single<Result<Bool, LoginError>> {
        return loginUseCase.execute(
            userID: userID,
            password: password
        )
        .flatMap{ result in
            switch result {
            case .success(let loginResponse):
                guard let refreshToken = loginResponse.refreshToken else {
                    return .just(.failure(.genericError(
                        NSError(
                            domain: "TokenError",
                            code: -1,
                            userInfo: [NSLocalizedDescriptionKey: "Missing token"]
                        )
                    )))
                }
                self.tokenSaveUseCase.saveTokens(
                    accessToken: loginResponse.accessToken,
                    refreshToken: refreshToken
                )
                return .just(.success(true))
            case .failure(let error):
                return .just(.failure(error))
            }
        }
    }
    
    func loadUser() {
        let viewModel = LoginViewModel(ID: userID, Password: password)
        delegate?.loadUser(viewModel: viewModel)
    }
    
    func didEndEditing(ID: String) {
        self.userID = ID
    }
    
    func didEndEditing(password: String) {
        self.password = password
    }
}
