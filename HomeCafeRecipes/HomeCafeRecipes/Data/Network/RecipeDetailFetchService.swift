//
//  RecipeDetailFetchService.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 6/26/24.
//

import Foundation
import RxSwift

protocol RecipeDetailFetchService {
    func fetchRecipeDetail(recipeId: Int) -> Single<Recipe>
}

class RecipeDetailFetchServiceImpl: RecipeDetailFetchService {
    private let networkService: NetworkService
    private static let baseURL: URL = URL(string: "https://meog0.store/api")!
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    private func makeURL(recipeId: Int) -> URL? {
        return RecipeDetailFetchServiceImpl.baseURL.appendingPathComponent("recipes/\(recipeId)")
    }
    
    func fetchRecipeDetail(recipeId: Int) -> Single<Recipe> {
        guard let URL = makeURL(recipeId: recipeId) else {
            return Single.error(NSError(domain: "URLComponentsError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }
        return networkService.getRequest(url: URL, responseType: NetworkResponseDTO<RecipeDetailDTO>.self)
            .map { $0.data.toDomain() }
    }
}
