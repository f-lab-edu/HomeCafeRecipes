//
//  SignUpView.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 9/1/24.
//

import UIKit

protocol SignupviewDelegate: AnyObject {
    func didTapBackButton()
    func didTapSignupButton()
    func didTapcheckNicknameButton()
    func didUpdateTextFields()
}

final class SignUpView: UIView {
    private let IDLabel: UILabel = {
        let IDLabel = UILabel()
        IDLabel.text = "아이디"
        IDLabel.font = Fonts.detailBodyFont
        return IDLabel
    }()
    
    private let IDField: UITextField = {
        let IDTextField = UITextField()
        IDTextField.placeholder = "Enter your ID"
        IDTextField.borderStyle = .roundedRect
        IDTextField.isEnabled = false
        return IDTextField
    }()
    
    private let nicknameLabel: UILabel = {
        let nicknameLabel = UILabel()
        nicknameLabel.text = "닉네임"
        nicknameLabel.font = Fonts.detailBodyFont
        return nicknameLabel
    }()
    
    private lazy var nicknameField: UITextField = { [weak self]  in
        let nicknameTextField = UITextField()
        nicknameTextField.borderStyle = .roundedRect
        return nicknameTextField
    }()
    
    lazy var checkNicknameButton: UIButton = {
        let checkNicknameButton = UIButton()
        checkNicknameButton.setTitle("중복 확인", for: .normal)
        checkNicknameButton.backgroundColor = .systemBlue
        checkNicknameButton.titleLabel?.font = Fonts.detailBodyFont
        checkNicknameButton.layer.cornerRadius = 8
        checkNicknameButton.addAction(
            UIAction(
                handler: { [weak self] _ in
                    self?.delegate?.didTapcheckNicknameButton()
                }
            ),
            for: .touchUpInside
        )
        return checkNicknameButton
    }()
    
    private let passwordLabel: UILabel = {
        let passwordLabel = UILabel()
        passwordLabel.text = "비밀번호"
        passwordLabel.font = Fonts.detailBodyFont
        return passwordLabel
    }()
    
    private lazy var passwordField: UITextField = { [weak self]  in
        let passwordField = UITextField()
        passwordField.placeholder = "Enter your password"
        passwordField.borderStyle = .roundedRect
        passwordField.isSecureTextEntry = true
        passwordField.addTarget(self, action: #selector(self?.handleTextFieldEditing), for: .editingChanged)
        return passwordField
    }()
    
    private let passwordCheckLabel: UILabel = {
        let passwordLabel = UILabel()
        passwordLabel.text = "비밀번호 확인"
        passwordLabel.font = Fonts.detailBodyFont
        return passwordLabel
    }()
    
    private lazy var passwordCheckField: UITextField = { [weak self]  in
        let passwordCheckField = UITextField()
        passwordCheckField.placeholder = "Enter your password"
        passwordCheckField.borderStyle = .roundedRect
        passwordCheckField.isSecureTextEntry = true
        passwordCheckField.addTarget(
            self,
            action: #selector(self?.handleTextFieldEditing),
            for: .editingChanged
        )
        return passwordCheckField
    }()
    
    lazy var signUpButton: UIButton = {
        let signUpButton = UIButton()
        signUpButton.setTitle("회원가입", for: .normal)
        signUpButton.backgroundColor = .lightGray
        signUpButton.titleLabel?.font = Fonts.detailBodyFont
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.layer.cornerRadius = 8
        signUpButton.isEnabled = false
        signUpButton.addAction(
            UIAction(
                handler: { [weak self] _ in
                    self?.delegate?.didTapSignupButton()
                }
            ),
            for: .touchUpInside
        )
        return signUpButton
    }()
    
    let customNavigationBar = CustomNavigationBar()
    
    weak var delegate: SignupviewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        setupNavigationBar()
        addsubviews()
        setupConstraints()
    }
    
    private func setupNavigationBar() {
        addSubview(customNavigationBar)
        customNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        customNavigationBar.setTitle("회원가입")
        customNavigationBar.backButton.addAction(
            UIAction(
                handler: { [weak self] _ in
                    self?.delegate?.didTapBackButton()
                }
            ),
            for: .touchUpInside
        )
    }
    
    private func addsubviews() {
        addSubview(nicknameLabel)
        addSubview(nicknameField)
        addSubview(IDLabel)
        addSubview(IDField)
        addSubview(checkNicknameButton)
        addSubview(passwordLabel)
        addSubview(passwordField)
        addSubview(passwordCheckLabel)
        addSubview(passwordCheckField)
        addSubview(signUpButton)
    }
    
    private func setupConstraints() {
        IDLabel.translatesAutoresizingMaskIntoConstraints = false
        IDField.translatesAutoresizingMaskIntoConstraints = false
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        nicknameField.translatesAutoresizingMaskIntoConstraints = false
        checkNicknameButton.translatesAutoresizingMaskIntoConstraints = false
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordCheckLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordCheckField.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            customNavigationBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            customNavigationBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            customNavigationBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            customNavigationBar.heightAnchor.constraint(equalToConstant: 44),
            
            IDLabel.topAnchor.constraint(equalTo: customNavigationBar.bottomAnchor, constant: 150),
            IDLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            IDLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            IDField.topAnchor.constraint(equalTo: IDLabel.bottomAnchor, constant: 10),
            IDField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            IDField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            nicknameLabel.topAnchor.constraint(equalTo: IDField.bottomAnchor, constant: 20),
            nicknameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            nicknameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            nicknameField.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 10),
            nicknameField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            checkNicknameButton.centerYAnchor.constraint(equalTo: nicknameField.centerYAnchor),
            checkNicknameButton.leadingAnchor.constraint(equalTo: nicknameField.trailingAnchor, constant: 10),
            checkNicknameButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            checkNicknameButton.widthAnchor.constraint(equalToConstant: 100),
            
            passwordLabel.topAnchor.constraint(equalTo: nicknameField.bottomAnchor, constant: 20),
            passwordLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            passwordLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            passwordField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 10),
            passwordField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            passwordField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            passwordCheckLabel.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 20),
            passwordCheckLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            passwordCheckLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            passwordCheckField.topAnchor.constraint(equalTo: passwordCheckLabel.bottomAnchor, constant: 10),
            passwordCheckField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            passwordCheckField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            signUpButton.topAnchor.constraint(equalTo: passwordCheckField.bottomAnchor, constant: 30),
            signUpButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            signUpButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            signUpButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func setEmail(email: String) {
        IDField.text = email
    }
    
    @objc private func handleTextFieldEditing(_ textField: UITextField) {
        delegate?.didUpdateTextFields()
    }
    
    var nickname: String {
        return nicknameField.text ?? ""
    }
    
    var password: String {
        return passwordField.text ?? ""
    }
    
    var passwordCheck: String {
        return passwordCheckField.text ?? ""
    }
}
