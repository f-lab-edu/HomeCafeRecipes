//
//  RecipeDTO.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 6/10/24.
//

import Foundation

struct RecipeDTO: Decodable {
    
    let id: Int
    let type: String
    let name: String
    let description: String
    let likesCount: Int
    let createdAt: String
    let writer: UserDTO
    let imageUrls: [RecipeImageDTO]
        
    enum CodingKeys: String, CodingKey {
        case id = "recipeId"
        case type = "recipeType"
        case name = "recipeName"
        case description = "recipeDescription"
        case likesCount = "recipeLikesCnt"
        case createdAt = "createdAt"
        case writer = "writer"
        case imageUrls = "recipeImgUrls"
    }
}

extension RecipeDTO {
    func toDomain() -> Recipe {
        return Recipe(
            id: id,
            type: RecipeType(rawValue: type) ?? .coffee,
            name: name,
            description: description,
            writer: writer.toDomain(),
            imageUrls: imageUrls.map { $0.recipeImageUrl },
            isLiked: false,
            likeCount: likesCount,
            createdAt: DateFormatter.iso8601.date(from: createdAt) ?? Date()
        )
    }
}
