//
//  RecipeDetailInteractor.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 6/27/24.
//

import Foundation

import RxSwift

protocol RecipeDetailInteractorDelegate: AnyObject {
    func fetchedRecipe(result: Result<Recipe, Error>)
}

protocol RecipeDetailInteractor {
    func viewDidLoad()    
}

class RecipeDetailInteractorImpl: RecipeDetailInteractor {
    
    private let fetchRecipeDetailUseCase: FetchRecipeDetailUseCase
    private let recipeID: Int
    private let disposeBag = DisposeBag()
    weak var delegate: RecipeDetailInteractorDelegate?
    
    init(
        fetchRecipeDetailUseCase: FetchRecipeDetailUseCase,
        recipeID: Int
    ) {
        self.fetchRecipeDetailUseCase = fetchRecipeDetailUseCase
        self.recipeID = recipeID
    }
        
    func viewDidLoad() {
        fetchRecipeDetail()
    }
    
    private func fetchRecipeDetail() {
        fetchRecipeDetailUseCase.execute(recipeID: recipeID)
            .subscribe(onSuccess: { [weak self] result in
                self?.delegate?.fetchedRecipe(result: result)
            }, onFailure: { [weak self] error in
                self?.delegate?.fetchedRecipe(result: .failure(error))
            })
            .disposed(by: disposeBag)
    }
}
