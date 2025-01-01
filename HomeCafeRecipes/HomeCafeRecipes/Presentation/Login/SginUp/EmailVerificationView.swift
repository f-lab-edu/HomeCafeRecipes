//
//  EmailVerificationView.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 12/16/24.
//

import UIKit

protocol EmailVerificationViewDelegate: AnyObject {
    // MARK: 인증번호 재전송 메서드
    func didTapResendCode()
    // MARK: 인증번호발송 매서드 확인 메서드
    func didTapVerificationCodeButton()
    // MARK: 인증번호 확인 매서드
    func didTapCompleteVerification()
    func didTapBackButton()
}

final class EmailVerificationView: UIView {
    private let emailPromptLabel: UILabel = {
        let emailPromptLabel = UILabel()
        emailPromptLabel.text = "이메일을 입력해 주세요"
        emailPromptLabel.font = Fonts.detailTitleFont
        return emailPromptLabel
    }()
    
    private lazy var emailTextField: UITextField = {
        let emailTextField = UITextField()
        emailTextField.borderStyle = .none
        emailTextField.addUnderline(color: .lightGray)
        return emailTextField
    }()
    
    private let verificationCodeLabel: UILabel = {
        let verificationCodeLabel = UILabel()
        verificationCodeLabel.text = "인증번호를 입력해 주세요"
        verificationCodeLabel.font = Fonts.detailTitleFont
        verificationCodeLabel.isHidden = true
        return verificationCodeLabel
    }()
    
    private lazy var verificationCodeTextField: UITextField = {
        let verificationCodeTextField = UITextField()
        verificationCodeTextField.borderStyle = .none
        verificationCodeTextField.placeholder = "인증번호를 입력해 주세요"
        verificationCodeTextField.addUnderline(color: .lightGray)
        verificationCodeTextField.isHidden = true
        return verificationCodeTextField
    }()
    
    private lazy var resendCodeButton: UIButton = {
        let resendCodeButton = UIButton()
        resendCodeButton.addAction(
            UIAction(
                handler: { [weak self] _ in
                    self?.delegate?.didTapResendCode()
                }
            ),
            for: .touchUpInside
        )
        return resendCodeButton
    }()
    
    private lazy var verificationActionButton: UIButton = {
        let verificationActionButton = UIButton()
        verificationActionButton.setTitle("인증하기", for: .normal)
        verificationActionButton.backgroundColor = .systemBlue
        verificationActionButton.titleLabel?.font = Fonts.detailBodyFont
        return verificationActionButton
    }()
    
    let customNavigationBar = CustomNavigationBar()
    
    weak var delegate: EmailVerificationViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        updateVerificationActionButton()
    }
    
    private func setupUI() {
        setupCustomNavigationBar()
        addsubviews()
        setupConstraints()        
    }
    
    private func setupCustomNavigationBar() {
        customNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        addSubview(customNavigationBar)
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
        addSubview(emailPromptLabel)
        addSubview(emailTextField)
        addSubview(verificationCodeLabel)
        addSubview(verificationCodeTextField)
        addSubview(resendCodeButton)
        addSubview(verificationActionButton)
    }
    
    private func setupConstraints() {
        emailPromptLabel.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        verificationCodeLabel.translatesAutoresizingMaskIntoConstraints = false
        verificationCodeTextField.translatesAutoresizingMaskIntoConstraints = false
        resendCodeButton.translatesAutoresizingMaskIntoConstraints = false
        verificationActionButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            customNavigationBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            customNavigationBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            customNavigationBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            customNavigationBar.heightAnchor.constraint(equalToConstant: 44),
            emailPromptLabel.topAnchor.constraint(equalTo: customNavigationBar.bottomAnchor, constant: 20),
            emailPromptLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            emailPromptLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            emailTextField.topAnchor.constraint(equalTo: emailPromptLabel.bottomAnchor, constant: 20),
            emailTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),
            
            verificationCodeLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 30),
            verificationCodeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            verificationCodeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            verificationCodeTextField.topAnchor.constraint(equalTo: verificationCodeLabel.bottomAnchor, constant: 10),
            verificationCodeTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            verificationCodeTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            verificationCodeTextField.heightAnchor.constraint(equalToConstant: 40),
            
            resendCodeButton.topAnchor.constraint(equalTo: verificationCodeTextField.bottomAnchor, constant: 10),
            resendCodeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            verificationActionButton.topAnchor.constraint(equalTo: resendCodeButton.bottomAnchor, constant: 40),
            verificationActionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            verificationActionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            verificationActionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateVerificationActionButton() {
        verificationActionButton.removeAllActions()
        
        if verificationCodeTextField.isHidden {
            verificationActionButton.setTitle("인증하기", for: .normal)
            verificationActionButton.addAction(
                UIAction { [weak self] _ in
                    self?.delegate?.didTapVerificationCodeButton()
                }, for: .touchUpInside
            )
        } else {
            verificationActionButton.setTitle("인증 완료", for: .normal)
            verificationActionButton.addAction(
                UIAction { [weak self] _ in
                    self?.delegate?.didTapCompleteVerification()
                }, for: .touchUpInside
            )
        }
    }
    
    var emailText: String {
        return emailTextField.text ?? ""
    }
    
    var verificationCodeText: String {
        return verificationCodeTextField.text ?? ""
    }
    
    func toggleVerificationCodeInput(isHidden: Bool) {
        verificationCodeTextField.isHidden = isHidden
        verificationCodeLabel.isHidden = isHidden
        resendCodeButton.isHidden = isHidden
        updateVerificationActionButton()
    }
    
    private func handleResendCodeButtonTap() {
        delegate?.didTapResendCode()
    }
}

private extension UIButton {
    func removeAllActions() {
        self.removeTarget(nil, action: nil, for: .allEvents)
    }
}
