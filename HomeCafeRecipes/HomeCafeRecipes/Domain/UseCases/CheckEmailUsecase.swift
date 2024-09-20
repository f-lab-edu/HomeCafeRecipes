//
//  CheckEmailUsecase.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 9/10/24.
//

import Foundation

import RxSwift

protocol CheckEmailUseCase {
    func execute(email: String) -> Single<Bool>
}

final class CheckEmailUseCaseImpl: CheckEmailUseCase {
    private let repository: CheckEmailRepository
    
    init(repository: CheckEmailRepository) {
        self.repository = repository
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: email)
    }
    
    func execute(email: String) -> Single<Bool> {
        guard isValidEmail(email) else {
            return Single.error(NSError(
                domain: "InvalidEmailError",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "잘못된 이메일 형식입니다."])
            )
        }
        return repository.checkEmail(userID: email)
    }
}
