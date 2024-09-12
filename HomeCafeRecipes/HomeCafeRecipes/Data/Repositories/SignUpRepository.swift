//
//  SignUpRepository.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 9/10/24.
//

import UIKit

import RxSwift

protocol SignUpRepository {
    func signUp(userNickName: String, userID: String, password: String) -> Single<Void>
}

final class SignUpRepositoryImpl: SignUpRepository {
    
    private let SignUpService: SignUpService
    
    init(SignUpService: SignUpService) {
        self.SignUpService = SignUpService
    }
    
    func signUp(userNickName: String, userID: String, password: String) -> Single<Void> {
        return SignUpService.signUp(
            userNickName: userNickName,
            userID: userID,
            password: password
        )
    }
}
