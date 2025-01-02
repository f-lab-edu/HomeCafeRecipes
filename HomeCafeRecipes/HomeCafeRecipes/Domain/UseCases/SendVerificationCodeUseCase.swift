//
//  SendVerificationCodeUseCase.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 12/19/24.
//

import UIKit

import RxSwift

protocol SendVerificationCodeUseCase {
    func execute(email: String) -> Single<Bool>
}

final class SendVerificationCodeUseCaseImpl: SendVerificationCodeUseCase {
    private let repository: SendVerificationCodeRepository
    
    init(repository: SendVerificationCodeRepository) {
        self.repository = repository
    }
    
    func execute(email: String) -> Single<Bool> {
        return repository.execute(email: email)
    }
}
