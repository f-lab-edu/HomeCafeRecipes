//
//  checkEmailRepository.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 9/10/24.
//

import Foundation

import RxSwift

protocol CheckEmailRepository {
    func checkEmail(userID: String) -> Single<Bool>
}

final class CheckEmailRepositoryImpl: CheckEmailRepository {
    private let signUpPostService: SignUpService
    
    init(signUpPostService: SignUpService) {
        self.signUpPostService = signUpPostService
    }
    
    func checkEmail(userID: String) -> Single<Bool> {
        return signUpPostService.checkEmail(userID: userID)
    }
}
