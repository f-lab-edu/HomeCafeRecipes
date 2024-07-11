//
//  RecipeDetailRepository.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 6/26/24.
//

import Foundation

import RxSwift

protocol RecipeDetailRepository {
    func fetchRecipeDetail(recipeID: Int) -> Single<Recipe>
}

class RecipeDetailRepositoryImpl: RecipeDetailRepository {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    private func makeURL(recipeId: Int) -> URL? {
        return APIConfig().baseURL.appendingPathComponent("recipes/\(recipeId)")
    }
    
    func fetchRecipeDetail(recipeID: Int) -> Single<Recipe> {
        guard let URL = makeURL(recipeId: recipeID) else {
            return Single.error(RecipeDetailError.invalidURL)
        }
        return networkService.getRequest(url: URL, responseType: NetworkResponseDTO<RecipeDetailDTO>.self)
            .map { $0.data.toDomain() }
            .catch { error in
                if let decodingError = error as? DecodingError {
                    return Single.error(RecipeDetailError.decodingError)
                } else {
                    return Single.error(RecipeDetailError.networkError(error))
                }
            }
    }
}
