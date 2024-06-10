//
//  RecipeDTO.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 6/10/24.
//

import Foundation

struct RecipesResponseDTO: Decodable {
    let statusCode: Int
    let message: String
    let data: [RecipeDTO]
}

struct RecipeDTO: Decodable {
    let recipeId: Int
    let recipeType: String
    let recipeName: String
    let recipeDescription: String
    let recipeLikesCnt: Int
    let createdAt: String
    let writer: UserDTO
    let recipeImgUrls: [RecipeImageDTO]
}

struct RecipeImageDTO: Decodable {
    let recipeImgId: Int
    let recipeImgUrl: String
}

extension RecipeDTO {
    func toDomain() -> Recipe {
        return Recipe(
            id: recipeId,
            type: RecipeType(rawValue: recipeType) ?? .dessert,
            name: recipeName,
            description: recipeDescription,
            writer: writer.toDomain(),
            imageUrls: recipeImgUrls.map { $0.recipeImgUrl },
            isLiked: false,
            likeCount: recipeLikesCnt,
            createdAt: DateFormatter.iso8601.date(from: createdAt) ?? Date()
        )
    }
}


