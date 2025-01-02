//
//  SendVerificationCodeRepository.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 12/19/24.
//

import UIKit

import RxSwift

protocol SendVerificationCodeRepository {
    func execute(email: String) -> Single<Bool>
}

final class SendVerificationCodeRepositoryImpl: SendVerificationCodeRepository {
    private let service: SendVerificationCodeService
    
    init(service: SendVerificationCodeService) {
        self.service = service
    }
    
    func execute(email: String) -> Single<Bool> {
        return service.checkVerifyCodeRequest(email: email)
            
    }
}
