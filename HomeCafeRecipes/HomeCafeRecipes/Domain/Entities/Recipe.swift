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
    
    static func dummyRecipe() -> Recipe {
        .init(
            id: 1,
            type: .coffee,
            name: "",
            description: "",
            writer: .init(
                id: 1,
                profileImage: "",
                nickname: "",
                createdAt: Date()
            ),
            imageUrls: [],
            isLikedByCurrentUser: false,
            likeCount: 0,
            createdAt: Date()
        )
    }
}
