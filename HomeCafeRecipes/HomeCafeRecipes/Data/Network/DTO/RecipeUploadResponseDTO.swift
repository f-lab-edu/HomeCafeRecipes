//
//  RecipeUploadResponseDTO.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 7/2/24.
//

import Foundation

struct RecipeUploadResponseDTO: Decodable {

    let ID: Int
    let type: String
    let name: String
    let description: String
    let likesCount: Int
    let createdAt: String
    let writer: UserDTO
    let imageUrls: [RecipeImageDTO]
    let isLikedByCurrentUser: Bool
        
    enum CodingKeys: String, CodingKey {
        case ID = "recipeId"
        case type = "recipeType"
        case name = "recipeName"
        case description = "recipeDescription"
        case likesCount = "recipeLikesCnt"
        case createdAt = "createdAt"
        case writer = "writer"
        case imageUrls = "recipeImgUrls"
        case isLikedByCurrentUser = "isLiked"
    }
        
}

extension RecipeUploadResponseDTO {
    func toDomain() -> Recipe {
        return Recipe(
            id: ID,
            type: RecipeType(rawValue: type) ?? .coffee,
            name: name,
            description: description,
            writer: writer.toDomain(),
            imageUrls: imageUrls.map { $0.recipeImageUrl },
            isLikedByCurrentUser: isLikedByCurrentUser,
            likeCount: likesCount,
            createdAt: DateFormatter.iso8601.date(from: createdAt) ?? Date()
        )
    }
}
