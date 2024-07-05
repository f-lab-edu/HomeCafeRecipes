//
//  RecipeItemViewModel.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 6/13/24.
//

import Foundation

struct RecipeDetailViewModel {
    let id: Int
    let recipeName: String
    let recipeDescription: String
    let recipeImageUrls: [URL]
    let isLiked: Bool
    
    init(recipe: Recipe) {
        self.id = recipe.id
        self.recipeName = recipe.name
        self.recipeDescription = recipe.description
        self.recipeImageUrls = recipe.imageUrls.compactMap { URL(string: $0) }
        self.isLiked = recipe.isLikedByCurrentUser
    }
}
