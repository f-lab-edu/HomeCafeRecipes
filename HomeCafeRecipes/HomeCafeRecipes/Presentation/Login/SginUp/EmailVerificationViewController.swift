//
//  EmailVerificationViewController.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 12/16/24.
//

import UIKit

import RxSwift

final class EmailVerificationViewController: UIViewController {
    private let contentView = EmailVerificationView()
    private let emailVerificationinteractor: EmailVerificationInteractor
    private let router: LoginRouter
    private let disposeBag = DisposeBag()
    
    init(interactor: EmailVerificationInteractor, router: LoginRouter) {
        self.emailVerificationinteractor = interactor
        self.router = router
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
        contentView.toggleVerificationCodeInput(isHidden: true)
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
    
    private func sendVerificationCode() {
        let emailText = contentView.emailText
        guard !emailText.isEmpty else {
            self.showCompletedAlert(
                title: "오류",
                message: "이메일을 입력해주세요",
                success: false
            )
            return
        }
        emailVerificationinteractor.updateEmail(emailText)
        emailVerificationinteractor.sendVerificationCode()
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] success in
                self?.handleVerificationResponse(
                    isSuccess: success,
                    successMessage: "인증번호가 전송되었습니다.",
                    failureMessage: "인증번호 전송에 실패했습니다."
                )
            }, onFailure: { [weak self] error in
                self?.showCompletedAlert(
                    title: "오류",
                    message: error.localizedDescription,
                    success: false
                )
            })
            .disposed(by: disposeBag)
    }
    
    private func validateEmailCode() {
        let code = contentView.verificationCodeText
        guard !code.isEmpty else {
            self.showCompletedAlert(
                title: "오류",
                message: "코드를 입력해주세요",
                success: false
            )
            return
        }
        emailVerificationinteractor.updateVerificationCode(code)
        emailVerificationinteractor.validateEmailCode()
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] success in
                self?.handleVerificationResponse(
                    isSuccess: success,
                    successMessage: "인증되었습니다.",
                    failureMessage: "인증에 실패했습니다."
                )
            }, onFailure: { [weak self] error in
                self?.showCompletedAlert(
                    title: "오류",
                    message: error.localizedDescription,
                    success: false
                )
            })
            .disposed(by: disposeBag)
    }
    
    private func handleVerificationResponse(
        isSuccess: Bool,
        successMessage: String,
        failureMessage: String
    ) {
        let title = isSuccess ? "성공" : "오류"
        let message = isSuccess ? successMessage : failureMessage
        self.showCompletedAlert(title: title, message: message, success: false)
        
        if isSuccess {
            self.contentView.toggleVerificationCodeInput(isHidden: false)
        }
    }
}


extension EmailVerificationViewController: EmailVerificationViewDelegate {
    func didTapCompleteVerification() {
        validateEmailCode()
    }
    
    func didTapResendCode() {
        sendVerificationCode()
    }
    
    func didTapVerificationCodeButton() {
        sendVerificationCode()
    }
    
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}

extension EmailVerificationViewController: Drawable {
    var viewController: UIViewController? {
        return self
    }
}
