//
//  ValidateEmailCodeRepository.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 12/24/24.
//

import Foundation

import RxSwift

protocol ValidateEmailCodeRepository {
    func checkVerificationCode(email:String, code: String) -> Single<Bool>
}

final class ValidateEmailCodeRepositoryImpl: ValidateEmailCodeRepository {
    private let service: EmailVerificationCodeService
    init(service: EmailVerificationCodeService) {
        self.service = service
    }
    func checkVerificationCode(email: String, code: String) -> Single<Bool> {
        return service.validateEmailCode(email: email, code: code)
    }
}
