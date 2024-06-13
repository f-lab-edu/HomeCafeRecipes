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
