//
//  RecipeListItemViewModel.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 6/12/24.
//

import Foundation

struct RecipeListItemViewModel {
    let id: Int
    let name: String
    let imageURL: URL?

    init(recipe: Recipe) {
        self.id = recipe.id
        self.name = recipe.name
        self.imageURL = URL(string: recipe.imageUrls.first ?? "")
    }
}
