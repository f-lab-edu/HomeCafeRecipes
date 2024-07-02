//
//  RecipeItemViewModel.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 6/13/24.
//

import Foundation

struct RecipeDetailViewModel {
    let id: Int
    let name: String
    let description: String
    let imageUrls: [URL]
    let isLikedByCurrentUser: Bool
    let createdAt: Date
    
    init(recipe: Recipe) {
        self.id = recipe.id
        self.name = recipe.name
        self.description = recipe.description
        self.imageUrls = recipe.imageUrls.compactMap { URL(string: $0) }
        self.isLikedByCurrentUser = recipe.isLikedByCurrentUser
        self.createdAt = recipe.createdAt
    }
}
