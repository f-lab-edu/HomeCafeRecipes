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
    private var signUpViewModel: SignUpViewModel?
    
    
    init(signUpInteractor: SignUpInteractor, router: LoginRouter){
        self.signUpInteractor = signUpInteractor
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
        signUpInteractor.didEndEditing(userNickName: contentView.nickname)
        signUpInteractor.didEndEditing(password: contentView.password)
        signUpInteractor.didEndEditing(checkpassword: contentView.passwordCheck)
        
        signUpInteractor.signUp()
            .subscribe(onSuccess: { [weak self] error in
                if let error = error {
                    DispatchQueue.main.async {
                        self?.showCompletedAlert(title: error.title, message: "\(error.errorDescription!)", success: false)
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.showCompletedAlert(title: "회원가입 성공", message: "회원가입에 성공했습니다.", success: true)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func checkEmail() {
        signUpInteractor.didEndEditing(userID: contentView.ID)
        
        signUpInteractor.checkEmail()
            .subscribe(onSuccess: { [weak self] isAvailable in
                DispatchQueue.main.async {
                    if (isAvailable == false) {
                        self?.showCompletedAlert(title: "이메일 사용 가능", message: "이메일을 사용할 수 있습니다.", success: false)
                        self?.contentView.IDField.isEnabled = false
                    } else {
                        self?.showCompletedAlert(title: "이메일 사용 불가", message: "이미 사용 중인 이메일입니다.", success: false)
                    }
                }
            }, onFailure: { [weak self] error in
                DispatchQueue.main.async {
                    self?.showCompletedAlert(title: "오류", message: error.localizedDescription, success: false)
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: SignupviewDelegate

extension SignUpViewController: SignupviewDelegate {
    func didUpdateTextFields() {
        let isNicknameValid = !contentView.nickname.isEmpty
        let isIDValid = !contentView.ID.isEmpty
        let isPasswordValid = !contentView.password.isEmpty
        let isPasswordCheckValid = !contentView.passwordCheck.isEmpty
        let isFormValid = isNicknameValid && isIDValid && isPasswordValid && isPasswordCheckValid

        contentView.signUpButton.isEnabled = isFormValid
        contentView.signUpButton.backgroundColor = isFormValid ? .systemBlue : .lightGray
    }
    
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    func didTapSignupButton() {
        signUp()
    }
    
    func didTapcheckEmailButton() {
        checkEmail()
    }
}

// MARK: Drawable

extension SignUpViewController: Drawable {
    var viewController: UIViewController? {
        return self
    }
}
