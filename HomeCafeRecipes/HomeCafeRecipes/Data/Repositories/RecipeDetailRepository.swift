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

class FeedListRepositoryImpl: RecipeDetailRepository {
    private let networkService: RecipeDetailFetchService
    
    init(networkService: RecipeDetailFetchService) {
        self.networkService = networkService
    }
    
    func fetchRecipeDetail(recipeID: Int) -> Single<Recipe> {
        return networkService.fetchRecipeDetail(recipeID: recipeID)
    }
}
