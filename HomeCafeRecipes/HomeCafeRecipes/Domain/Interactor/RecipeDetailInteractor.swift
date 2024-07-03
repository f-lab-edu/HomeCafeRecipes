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

protocol InputRecipeDetailInteractor {
    func viewDidLoad()
}

protocol OutputRecipeDetailInteractor {
    var recipe: Observable<Result<Recipe, Error>> { get }
}

class RecipeDetailInteractor: InputRecipeDetailInteractor, OutputRecipeDetailInteractor {

    private let fetchRecipeDetailUseCase: FetchRecipeDetailUseCase
    private let recipeID: Int
    private let disposeBag = DisposeBag()
    private let recipeDetailSubject = PublishSubject<Result<Recipe, Error>>()
    weak var delegate: RecipeDetailInteractorDelegate?

    var recipe: Observable<Result<Recipe, Error>> {
        return recipeDetailSubject.asObservable()
    }

    init(fetchRecipeDetailUseCase: FetchRecipeDetailUseCase, recipeID: Int) {
        self.fetchRecipeDetailUseCase = fetchRecipeDetailUseCase
        self.recipeID = recipeID
    }
    
    func setDelegate(_ delegate: RecipeDetailInteractorDelegate) {
        self.delegate = delegate
        bindOutputs()
    }

    private func bindOutputs() {
        recipe
            .subscribe(onNext: { [weak self] result in
                self?.delegate?.fetchedRecipe(result: result)
            })
            .disposed(by: disposeBag)
    }

    func viewDidLoad() {
        fetchRecipeDetail()
    }

    private func fetchRecipeDetail() {
        fetchRecipeDetailUseCase.execute(recipeID: recipeID)
            .subscribe { [weak self] result in
                self?.handleResult(result)
            }
            .disposed(by: disposeBag)
    }

    private func handleResult(_ result: Result<Recipe, Error>) {
        switch result {
        case .success(let recipe):
            self.recipeDetailSubject.onNext(.success(recipe))
        case .failure(let error):
            self.recipeDetailSubject.onNext(.failure(error))
        }
    }
}
