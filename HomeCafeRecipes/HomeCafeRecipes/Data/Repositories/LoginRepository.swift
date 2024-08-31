//
//  LoginRepository.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 8/31/24.
//

import Foundation

import RxSwift

protocol LoginRepository {
    func login(userID: String, password: String) -> Single<User>
}

final class LoginRepositoryImpl: LoginRepository {
    
    private let loginService: LoginService
    
    init(loginService: LoginService) {
        self.loginService = loginService
    }
    
    func login(userID: String, password: String) -> Single<User> {
        return loginService.login(userID: userID,password: password)
    }
}
