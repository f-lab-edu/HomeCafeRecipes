//
//  AddRecipeRepository.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 7/1/24.
//

import Foundation
import UIKit

import RxSwift

protocol AddRecipeRepository {
    func saveRecipe(
        userID: Int,
        recipeType: String,
        title: String,
        description: String,
        images: [UIImage]
    ) -> Single<Recipe>
}

class AddRecipeRepositoryImpl: AddRecipeRepository {
    private let recipePostService: RecipePostService
    
    init(recipePostService: RecipePostService) {
        self.recipePostService = recipePostService
    }
    
    func saveRecipe(
        userID: Int,
        recipeType: String,
        title: String,
        description: String,
        images: [UIImage]
    ) -> Single<Recipe> {
        let recipeUploadDTO = RecipeUploadDTO(
            userID: userID,
            recipeType: recipeType,
            recipeName: title,
            recipeDescription: description
        )
        return recipePostService.postRecipe(recipe: recipeUploadDTO, images: images)
    }
}
