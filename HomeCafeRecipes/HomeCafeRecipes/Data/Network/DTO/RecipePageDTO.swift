//
//  RecipePageDTO.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 6/12/24.
//

import Foundation

struct RecipePageDTO: Decodable {
    let totalPageNumber: Int
    let pageNumber: Int
    let lastBoundaryId: Int
    let recipes: [RecipeDTO]

    private enum CodingKeys: String, CodingKey {
        case totalPageNumber = "totalPageNumber"
        case pageNumber = "pageNumber"
        case lastBoundaryId = "lastBoundaryId"
        case recipes = "recipes"
    }
}
