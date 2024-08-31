//
//  LoginViewController.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 8/27/24.
//

import UIKit

import RxSwift

final class LoginViewController: UIViewController {
    
    private let contentView =  LoginView()
    private let loginInteractor: LoginInteractor
    private let disposeBag = DisposeBag()
    private var loginViewModel: LoginViewModel?
    
    init(loginInteractor: LoginInteractor) {
        self.loginInteractor = loginInteractor
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
        contentView.delegate = self
        setupUI()
        loginInteractor.loadUser()
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
    
    private func showCompletedAlert(title: String, message: String, success: Bool) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            if success {
                self.navigationController?.popViewController(animated: true)
            }
        }
        alert.addAction(confirmAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func login(ID: String, password: String) {
        loginInteractor.login(userID: ID, password: password)
            .subscribe(onSuccess: { [weak self] result in
                switch result {
                case .success:
                    print("LOGINSuccess")
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.showCompletedAlert(
                            title: error.title,
                            message: error.localizedDescription,
                            success: false
                        )
                    }
                }
            })
            .disposed(by: disposeBag)
    }
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
