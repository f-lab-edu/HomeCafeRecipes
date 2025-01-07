//
//  EmailVerificationInteractor.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 12/16/24.
//

import UIKit
import RxSwift

// MARK: - Protocols

protocol EmailVerificationInteractor {
    var email: String { get }
    func updateEmail(_ email: String)
    func updateVerificationCode(_ code: String)
    func sendVerificationCode() -> Single<Bool>
    func validateEmailCode() -> Single<Bool>
}

protocol EmailVerificationInteractorDelegate: AnyObject {
    func didCheckEmail(isAvailable: Bool)
    func didSendVerificationCode(success: Bool)
    func didVerifyCode(success: Bool)
    func didCompleteSignUp(success: Bool, error: Error?)
}

// MARK: - Implementation

final class EmailVerificationInteractorImpl: EmailVerificationInteractor {
    
    // MARK: - Properties
    
    var email: String = ""
    private var verificationCode: String = ""
        
    private let sendVerificationCodeUseCase: SendVerificationCodeUseCase
    private let validateEmailCodeUseCase: ValidateEmailCodeUseCase
    
    private let disposeBag = DisposeBag()
    weak var delegate: EmailVerificationInteractorDelegate?
    
    
    init(sendVerificationCodeUseCase: SendVerificationCodeUseCase,
         validateEmailCodeUseCase:ValidateEmailCodeUseCase
    ) {
        self.sendVerificationCodeUseCase = sendVerificationCodeUseCase
        self.validateEmailCodeUseCase = validateEmailCodeUseCase
    }
        
    func updateEmail(_ email: String) {
        self.email = email
    }
    
    func updateVerificationCode(_ code: String) {
        self.verificationCode = code
    }

    func sendVerificationCode() -> Single<Bool> {
        return sendVerificationCodeUseCase.execute(email: email)
    }
    
    func validateEmailCode() -> Single<Bool> {
        return validateEmailCodeUseCase.excute(email: email, code: verificationCode)
    }
}
