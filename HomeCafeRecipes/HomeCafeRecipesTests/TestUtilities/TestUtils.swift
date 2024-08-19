//
//  TestUtils.swift
//  HomeCafeRecipesTests
//
//  Created by 김건호 on 8/14/24.
//

import Foundation

class TestUtils {
    static func areRecipesEqual(_ lhs: [Recipe], _ rhs: [Recipe]) -> Bool {
        guard lhs.count == rhs.count else { return false }
        for (index, recipe) in lhs.enumerated() {
            if recipe.id != rhs[index].id ||
                recipe.type != rhs[index].type ||
                recipe.name != rhs[index].name ||
                recipe.description != rhs[index].description ||
                recipe.writer != rhs[index].writer ||
                recipe.imageUrls != rhs[index].imageUrls ||
                recipe.isLikedByCurrentUser != rhs[index].isLikedByCurrentUser ||
                recipe.likeCount != rhs[index].likeCount ||
                recipe.createdAt != rhs[index].createdAt {
                return false
            }
        }
        return true
    }
}
