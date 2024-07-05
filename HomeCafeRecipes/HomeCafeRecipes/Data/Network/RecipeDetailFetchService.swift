//
//  RecipeDetailFetchService.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 6/26/24.
//

import Foundation
import RxSwift

protocol RecipeDetailFetchService {
    func fetchRecipeDetail(recipeID: Int) -> Single<Recipe>
}

final class RecipeDetailFetchServiceImpl: RecipeDetailFetchService {
    private let networkService: NetworkService
    private static let baseURL: URL = URL(string: "https://meog0.store/api")!
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    private func makeURL(recipeID: Int) -> URL? {
        return RecipeDetailFetchServiceImpl.baseURL.appendingPathComponent("recipes/\(recipeID)")
    }
    
    func fetchRecipeDetail(recipeID: Int) -> Single<Recipe> {
        guard let URL = makeURL(recipeID: recipeID) else {
            return Single.error(NSError(domain: "URLComponentsError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }
        return networkService.getRequest(url: URL, responseType: NetworkResponseDTO<RecipeDetailDTO>.self)
            .map { $0.data.toDomain() }
    }
}
