//
//  RecipeDetailDTO.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 6/29/24.
//

import Foundation

struct RecipeDetailDTO: Decodable {
    let id: Int
    let name: String
    let description: String
    let likesCount: Int
    let createdAt: String
    let writer: UserDTO
    let imageUrls: [RecipeImageDTO]
    let isLikedByCurrentUser: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "recipeId"
        case name = "recipeName"
        case description = "recipeDescription"
        case likesCount = "recipeLikesCnt"
        case createdAt = "createdAt"
        case writer = "writer"
        case imageUrls = "recipeImages"
        case isLikedByCurrentUser = "isLiked"
    }
}

extension RecipeDetailDTO {
    func toDomain() -> Recipe {
        return Recipe(
            id: id,
            type: .coffee,
            name: name,
            description: description,
            writer: writer.toDomain(),
            imageUrls: imageUrls.map{ $0.recipeImageUrl },
            isLikedByCurrentUser: isLikedByCurrentUser,
            likeCount: likesCount,
            createdAt: DateFormatter.iso8601.date(from: createdAt) ?? Date()
        )
    }
}
