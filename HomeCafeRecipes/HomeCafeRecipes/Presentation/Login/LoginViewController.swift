//
//  LoginViewController.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 8/27/24.
//

import UIKit

final class LoginViewController: UIViewController {
    
    private let contentView =  LoginView()
    private var loginViewModel: LoginViewModel?
    
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.delegate = self
        setupUI()
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
    

extension LoginViewController: LoginViewDelegate {
    func didtapLoginButton() {
        let ID = contentView.ID
        let password = contentView.password
        loginInteractor.didEndEditing(ID: ID)
        loginInteractor.didEndEditing(password: password)
        login(ID: ID, password: password)
    }
}
