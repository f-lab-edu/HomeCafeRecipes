//
//  LoginUseCase.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 8/30/24.
//

import Foundation

import RxSwift

protocol LoginUseCase {
    func execute(userID: String, password: String) -> Single<Result<User,LoginError>>
}

class LoginUseCaseImpl: LoginUseCase {
    private let repository: LoginRepository
    
    init(repository: LoginRepository) {
        self.repository = repository
    }
    
    func execute(userID: String, password: String) -> Single<Result<User, LoginError>> {
        
        guard !userID.isBlank else {
            return .just(.failure(.IDIsEmpty))
        }
        
        guard !password.isBlank else {
            return .just(.failure(.passwordIsEmpty))
        }
        
        return repository.login(userID: userID, password: password)
            .map{ .success($0) }
            .catch { .just(.failure(.genericError($0))) }
            
    }
}
