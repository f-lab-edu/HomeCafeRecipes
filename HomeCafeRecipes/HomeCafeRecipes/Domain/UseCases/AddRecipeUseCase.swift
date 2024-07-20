//
//  SaveRecipeUseCase.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 7/1/24.
//

import UIKit

import RxSwift

protocol AddRecipeUseCase {
    func execute(
        userID: Int,
        recipeType: String,
        title: String,
        description: String,
        images: [UIImage]
    ) -> Single<Result<Recipe, AddRecipeError>>
}

class AddRecipeUseCaseImpl: AddRecipeUseCase {
    private let repository: AddRecipeRepository
    
    init(repository: AddRecipeRepository) {
        self.repository = repository
    }
    
    func execute(
        userID: Int,
        recipeType: String,
        title: String,
        description: String,
        images: [UIImage]
    ) -> Single<Result<Recipe, AddRecipeError>> {
        
        guard !images.isEmpty else {
            return .just(.failure(.noImages))
        }
        
        guard !title.isBlank else {
            return .just(.failure(.titleIsEmpty))
        }
        
        guard description.count > 10 else {
            return .just(.failure(.descriptionTooShort))
        }
        
        return repository.saveRecipe(
            userID: userID,
            recipeType: recipeType,
            title: title,
            description: description,
            images: images
        )
        .map { .success($0) }
        .catch { .just(.failure(.genericError($0))) }
    }
}
