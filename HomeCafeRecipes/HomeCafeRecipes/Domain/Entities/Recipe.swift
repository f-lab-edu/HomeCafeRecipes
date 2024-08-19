//
//  Recipe.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 6/9/24.
//

import Foundation

struct Recipe {
    let id: Int
    let type: RecipeType
    let name: String
    let description: String
    let writer: User
    let imageUrls: [String]
    let isLikedByCurrentUser: Bool
    let likeCount: Int
    let createdAt: Date
}

extension Recipe {
    
    static func dummyRecipe(
        id: Int = 1,
        type: RecipeType = .coffee,
        name: String = "",
        description: String = "",
        writer: User = .init(id: 1, profileImage: "", nickname: "", createdAt: Date()),
        imageUrls: [String] = [],
        isLikedByCurrentUser: Bool = false,
        likeCount: Int = 0,
        createdAt: Date = Date()
    ) -> Recipe {
        return Recipe(
            id: id,
            type: type,
            name: name,
            description: description,
            writer: writer,
            imageUrls: imageUrls,
            isLikedByCurrentUser: isLikedByCurrentUser,
            likeCount: likeCount,
            createdAt: createdAt
        )
    }
}
