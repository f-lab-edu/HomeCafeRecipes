//
//  SignUpInteractor.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 9/7/24.
//

import UIKit

import RxSwift

protocol SignUpViewControllerDelegate: AnyObject {
    func loadnewUser(viewModel: SignUpViewModel)
}

protocol SignUpInteractor {
    func loadNewUser()
    func signUp() -> Single<SignUpError?>
    func checkEmail() -> Single<Bool>
    func didEndEditing(userNickName: String)
    func didEndEditing(userID: String)
    func didEndEditing(password: String)
    func didEndEditing(checkpassword: String)
    
}

final class SignUpInteractorImpl: SignUpInteractor {
    
    private var userNickName: String = ""
    private var userID: String = ""
    private var password: String = ""
    private var checkpassword: String = ""
    
    weak var delegate: SignUpViewControllerDelegate?
    
    private let usecase: SignUpUseCase
    private let checkeEmailUsecase: CheckEmailUseCase
    
    
    init(usecase: SignUpUseCase,checkeEmailUsecase: CheckEmailUseCase){
        self.usecase = usecase
        self.checkeEmailUsecase = checkeEmailUsecase
    }
    
    func loadNewUser() {
        let viewmodel = SignUpViewModel(
            nickName: userNickName,
            ID: userID,
            password: password,
            checkpassword: checkpassword
        )
        delegate?.loadnewUser(viewModel: viewmodel)
    }
    
    func didEndEditing(userNickName: String) {
        self.userNickName = userNickName
    }
    
    func didEndEditing(userID: String) {
        self.userID = userID
    }
    
    func didEndEditing(password: String) {
        self.password = password
    }
    
    func didEndEditing(checkpassword: String) {
        self.checkpassword = checkpassword
    }
    
    func signUp() -> Single<SignUpError?> {
        return usecase.execute(
            userNickName: userNickName,
            userID: userID,
            password: password,
            checkpassword: checkpassword
        )
    }
    
    func checkEmail() -> Single<Bool> {        
        return checkeEmailUsecase.execute(email: userID)
    }
}
