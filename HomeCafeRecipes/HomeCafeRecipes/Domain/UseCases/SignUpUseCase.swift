//
//  SignUpUseCase.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 9/8/24.
//

import Foundation

import RxSwift

protocol SignUpUseCase {
    func execute(
        userNickName: String,
        userID: String,
        password: String,
        checkpassword: String
    ) -> Single<SignUpError?>
}

final class SignUpUseCaseImpl: SignUpUseCase {
    private let repository: SignUpRepository
    
    init(repository: SignUpRepository) {
        self.repository = repository
    }
    
    func execute(
        userNickName: String,
        userID: String,
        password: String,
        checkpassword: String
    ) -> Single<SignUpError?> {
        
        guard password.isCheck(equalTo: checkpassword) else {
            return .just(.passwordMismatch)
        }
        
        return repository.signUp(
            userNickName: userNickName,
            userID: userID,
            password: password
        )
        .map { _ in
            return nil
        }
        .catch { error in
            return .just(.genericError(error))
        }
    }
}
