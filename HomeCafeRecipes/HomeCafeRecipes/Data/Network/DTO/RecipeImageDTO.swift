//
//  RecipeImageDTO.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 6/11/24.
//

import Foundation

struct RecipeImageDTO: Decodable {
    let recipeImageID: Int
    let recipeImageUrl: String
    
    private enum CodingKeys: String, CodingKey {
        case recipeImageID = "recipeImageId"
        case recipeImageUrl = "recipeImageUrl"
    }
}
