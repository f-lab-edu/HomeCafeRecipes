//
//  RecipeItemViewModel.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 6/13/24.
//

import Foundation

struct RecipeDetailViewModel {
    let id: Int
    let RecipeName: String
    let RecipeDescription: String
    let RecipeImageUrls: [URL]
    let isLiked: Bool
    let createdAt: Date
    
    init(recipe: Recipe) {
        self.id = recipe.id
        self.RecipeName = recipe.name
        self.RecipeDescription = recipe.description
        self.RecipeImageUrls = recipe.imageUrls.compactMap { URL(string: $0) }
        self.isLiked = recipe.isLikedByCurrentUser
        self.createdAt = recipe.createdAt
    }
}
