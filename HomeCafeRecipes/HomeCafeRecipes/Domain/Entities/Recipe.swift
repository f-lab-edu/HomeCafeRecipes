//
//  FeedModel.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 5/16/24.
//

import Foundation

struct Recipe {
    let id: String
    let type: RecipeType
    let name: String
    let description: String
    let owner: User
    let imageURLs: [String]
    let comments: [Comment]
    let likes: [Like]
    let createdAt: Date
}
