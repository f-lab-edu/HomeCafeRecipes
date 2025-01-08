//
//  RecipeDTO.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 6/10/24.
//

import Foundation

struct RecipeDTO: Decodable {
    
    let ID: Int
    let name: String
    let likesCount: Int
    let writer: UserDTO
    let recipeImageUrl: String
    let isLikedByCurrentUser: Bool
        
    enum CodingKeys: String, CodingKey {
        case ID = "recipeId"
        case name = "recipeName"
        case likesCount = "recipeLikesCnt"
        case writer = "writer"
        case recipeImageUrl = "recipeImageUrl"
        case isLikedByCurrentUser = "isLiked"
    }
}

extension RecipeDTO {
    func toDomain() -> Recipe {
        return Recipe(
            id: ID,
            type: .coffee, // MARK: 임시 값 커피로 설정
            name: name,
            description: "",
            writer: writer.toDomain(),
            imageUrls: [recipeImageUrl],
            isLikedByCurrentUser: isLikedByCurrentUser,
            likeCount: likesCount,
            createdAt: Date()
        )
    }
}
