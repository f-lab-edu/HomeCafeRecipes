//
//  RecipesResponseDTO.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 6/11/24.
//

import Foundation

struct RecipesResponseDTO: Decodable {
    let statusCode: Int
    let message: String
    let data: [RecipeDTO]
}