//
//  SignUpViewController.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 9/1/24.
//

import UIKit

import RxSwift

final class SignUpViewController: UIViewController {
    private let contentView = SignUpView()
    private let signUpInteractor: SignUpInteractor
    private let disposeBag = DisposeBag()
    private let router: LoginRouter
    private let email: String
    private var signUpViewModel: SignUpViewModel?
    
    init(
        signUpInteractor: SignUpInteractor,
        router: LoginRouter,
        email: String
    ){
        self.signUpInteractor = signUpInteractor
        self.router = router
        self.email = email
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        contentView.delegate = self
        contentView.setEmail(email: email)
        signUpInteractor.didEndEditing(userID: email)
        signUpInteractor.loadNewUser()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func signUp() {
        signUpInteractor.didEndEditing(password: contentView.password)
        signUpInteractor.didEndEditing(checkpassword: contentView.passwordCheck)
        
        signUpInteractor.signUp()
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] error in
                guard let self = self else { return }
                self.showAlertForResult(
                    isSuccess: error == nil,
                    successTitle: "회원가입 성공",
                    successMessage: "회원가입에 성공했습니다.",
                    failureTitle: "회원가입 실패",
                    failureMessage: error?.errorDescription ?? "알 수 없는 오류",
                    onSuccess: {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                )
            })
            .disposed(by: disposeBag)
    }

    private func checkNickname() {
        signUpInteractor.didEndEditing(userNickName: contentView.nickname)
        signUpInteractor.checkNickname()
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] isDuplicate in
                guard let self = self else { return }
                self.showAlertForResult(
                    isSuccess: !isDuplicate,
                    successTitle: "닉네임 사용 가능",
                    successMessage: "사용 가능한 닉네임입니다. 이 닉네임을 사용하시겠습니까?",
                    failureTitle: "닉네임 중복",
                    failureMessage: "이미 사용 중인 닉네임입니다. 다른 닉네임을 입력해주세요.",
                    onSuccess: {
                        
                    },
                    onFailure: {
                        
                    }
                )
            }, onFailure: { [weak self] error in
                self?.showCompletedAlert(
                    title: "오류",
                    message: error.localizedDescription
                )
            })
            .disposed(by: disposeBag)
    }
    
    private func processVerificationResult(
        isSuccess: Bool,
        successMessage: String,
        failureMessage: String,
        onSuccess: (() -> Void)? = nil
    ) {
        let title = isSuccess ? "성공" : "오류"
        let message = isSuccess ? successMessage : failureMessage
        
        self.showCompletedAlert(
            title: title,
            message: message,
            onConfirm: {
                if isSuccess {
                    onSuccess?()
                }
            }
        )
    }
}

// MARK: SignupviewDelegate

extension SignUpViewController: SignupviewDelegate {
    func didUpdateTextFields() {
        let isNicknameValid = !contentView.nickname.isEmpty
        let isPasswordValid = !contentView.password.isEmpty
        let isPasswordCheckValid = !contentView.passwordCheck.isEmpty
        let isFormValid = isNicknameValid && isPasswordValid && isPasswordCheckValid
        
        contentView.signUpButton.isEnabled = isFormValid
        contentView.signUpButton.backgroundColor = isFormValid ? .systemBlue : .lightGray
    }
    
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    func didTapSignupButton() {
        signUp()
    }
    
    func didTapcheckNicknameButton() {
        checkNickname()
    }
}

extension SignUpViewController {
    private func showAlertForResult(
        isSuccess: Bool,
        successTitle: String,
        successMessage: String,
        failureTitle: String,
        failureMessage: String,
        onSuccess: (() -> Void)? = nil,
        onFailure: (() -> Void)? = nil
    ) {
        if isSuccess {
            showCompletedAlert(
                title: successTitle,
                message: successMessage,
                onConfirm: onSuccess
            )
        } else {
            showCompletedAlert(
                title: failureTitle,
                message: failureMessage,
                onConfirm: onFailure
            )
        }
    }
}


// MARK: Drawable

extension SignUpViewController: Drawable {
    var viewController: UIViewController? {
        return self
    }
}
