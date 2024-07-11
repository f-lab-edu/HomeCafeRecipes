//
//  FetchRecipeDetailUseCase.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 6/26/24.
//

import Foundation
import RxSwift

protocol FetchRecipeDetailUseCase {
    func execute(recipeID: Int) -> Single<Result<Recipe, Error>>
}

class FetchRecipeDetailUseCaseImpl: FetchRecipeDetailUseCase {
    private let repository: RecipeDetailRepository
    
    init(repository: RecipeDetailRepository) {
        self.repository = repository
    }
    
    func execute(recipeID: Int) -> Single<Result<Recipe, Error>> {
        return repository.fetchRecipeDetail(recipeID: recipeID)
            .map { recipe in
                return .success(recipe)
            }
            .catch { error in
                return .just(.failure(error))
            }
    }
}
