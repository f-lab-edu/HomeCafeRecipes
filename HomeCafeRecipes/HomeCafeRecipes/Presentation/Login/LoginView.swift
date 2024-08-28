//
//  LoginView.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 8/27/24.
//

import UIKit

final class LoginView: UIView {
    
    private let loginLabel: UILabel = {
        let loginLabel = UILabel()
        loginLabel.text = "아이디"
        loginLabel.font = Fonts.detailBodyFont
        return loginLabel
    }()
    
    private let loginField: UITextField = {
        let loginField = UITextField()
        loginField.placeholder = "Enter your email"
        loginField.borderStyle = .roundedRect
        return loginField
    }()
    private let passwordLabel: UILabel = {
        let passwordLabel = UILabel()
        passwordLabel.text = "비밀번호"
        passwordLabel.font = Fonts.detailBodyFont
        return passwordLabel
    }()
    
    private let passwordField: UITextField = {
        let passwordField = UITextField()
        passwordField.placeholder = "Enter your password"
        passwordField.isSecureTextEntry = true
        passwordField.borderStyle = .roundedRect
        return passwordField
    }()
    
    let loginButton: UIButton = {
        let loginButton = UIButton()
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = .systemBlue
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 8
        return loginButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addsubviews()
        setupConstraints()
    }
    
    private func addsubviews() {
        addSubview(loginLabel)
        addSubview(loginField)
        addSubview(passwordLabel)
        addSubview(passwordField)
        addSubview(loginButton)
    }
    
    private func setupConstraints() {
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        loginField.translatesAutoresizingMaskIntoConstraints = false
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loginLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,constant: 230),
            loginLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            loginField.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 10),
            loginField.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 20),
            loginField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            loginField.heightAnchor.constraint(equalToConstant: 40),
            passwordLabel.topAnchor.constraint(equalTo: loginField.bottomAnchor,constant: 10),
            passwordLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            passwordField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 10),
            passwordField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            passwordField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            passwordField.heightAnchor.constraint(equalToConstant: 40),
            loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 200),
            loginButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            loginButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        
        ])
    }
}
