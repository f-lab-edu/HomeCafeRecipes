//
//  RecipeMapper.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 6/14/24.
//

import Foundation

struct RecipeMapper {
    static func mapToRecipeListItemViewModels(from recipes: [Recipe]) -> [RecipeListItemViewModel] {
        return recipes.map { RecipeListItemViewModel(recipe: $0) }
    }

    static func mapToRecipeItemViewModel(from recipe: Recipe) -> RecipeItemViewModel {
        return RecipeItemViewModel(recipe: recipe)
    }
}
