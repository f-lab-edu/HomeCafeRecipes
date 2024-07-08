//
//  RecipeError.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 7/5/24.
//

import Foundation

enum RecipeDetailError: Error {
    case invalidURL
    case networkError(Error)
    case decodingError
    case unknownError
}

extension RecipeDetailError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .networkError(let error):
            return error.localizedDescription
        case .decodingError:
            return "Failed to decode the response"
        case .unknownError:
            return "An unknown error occurred"
        }
    }
}
