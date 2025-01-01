//
//  ValidateEmailCodeUseCase.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 12/24/24.
//

import Foundation

import RxSwift

protocol ValidateEmailCodeUseCase {
    func excute(email:String, code: String) -> Single<Bool>
}

final class ValidateEmailCodeUseCaseImpl: ValidateEmailCodeUseCase {
    private let repository: ValidateEmailCodeRepository
    
    init(repository: ValidateEmailCodeRepository) {
        self.repository = repository
    }
    
    func excute(email:String,code: String) -> Single<Bool> {
        return repository.checkVerificationCode(email:email, code: code)
    }
}
