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
    func login(userID: String, password: String) -> Single<Result<User, LoginError>>
    func loadUser()
    func didEndEditing(ID: String)
    func didEndEditing(password: String)
}

final class LoginInteractorImpl: LoginInteractor {
    
    private var userID: String = ""
    private var password: String = ""
    
    weak var delegate: LoginViewControllerDelegate?
    
    private let loginUseCase: LoginUseCase
    
    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
    }
    
    func login(userID: String, password: String) -> Single<Result<User, LoginError>> {
        return loginUseCase.execute(
            userID: userID,
            password: password
        )
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
