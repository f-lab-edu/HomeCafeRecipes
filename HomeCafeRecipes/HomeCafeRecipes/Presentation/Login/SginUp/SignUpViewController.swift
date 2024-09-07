//
//  SignUpViewController.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 9/1/24.
//

import UIKit

final class SignUpViewController: UIViewController {
    private let contentView = SignUpView()
    
    init() {
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
        return
    }
}

// MARK: Drawable

extension SignUpViewController: Drawable {
    var viewController: UIViewController? {
        return self
    }
}
