//
//  RecipeDetailViewController.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 6/14/24.
//

import UIKit
import RxSwift

final class RecipeDetailViewController: UIViewController {
    
    private let contentView = RecipeDetailView()
    private let customNavigationBar = CustomNavigationBar()
    private let interactor: RecipeDetailInteractor
    private let disposeBag = DisposeBag()
    private var recipeDetailViewModel: RecipeDetailViewModel?
    
    init(interactor: RecipeDetailInteractor) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
        self.interactor.setDelegate(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        interactor.viewDidLoad()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(contentView)
        view.addSubview(customNavigationBar)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        customNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            customNavigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            customNavigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customNavigationBar.heightAnchor.constraint(equalToConstant: 44),
            
            contentView.topAnchor.constraint(equalTo: customNavigationBar.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        customNavigationBar.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    private func displayError(_ error: Error) {
        let alert = UIAlertController(title: "해당 레시피를 로드하는데 실패했습니다.", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - RecipeDetailInteractorDelegate
extension RecipeDetailViewController: RecipeDetailInteractorDelegate {
    func fetchedRecipe(result: Result<Recipe, Error>) {
        switch result {
        case .success(let recipe):
            let recipeItemViewModel = RecipeListMapper().mapToRecipeDetailViewModel(from: recipe)
            DispatchQueue.main.async {
                self.contentView.configure(with: recipeItemViewModel)
            }
        case .failure(let error):
            DispatchQueue.main.async {
                self.displayError(error)
            }
        }
    }
}
