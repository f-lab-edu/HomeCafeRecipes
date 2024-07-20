//
//  RecipePostService.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 7/1/24.
//

import Foundation
import UIKit

import RxSwift

protocol RecipePostService {
    func postRecipe(recipe: RecipeUploadDTO, images: [UIImage]) -> Single<Recipe>
}

class RecipePostServiceImpl: RecipePostService {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    private func makeURL(endpoint: String) -> URL {
        return APIConfig().baseURL.appendingPathComponent(endpoint)
    }
    
    func postRecipe(recipe: RecipeUploadDTO, images: [UIImage]) -> Single<Recipe> {
        let url = makeURL(endpoint: "recipes")
        let parameters: [String: Any] = [
            "userId": recipe.userID,
            "recipeType": recipe.recipeType,
            "recipeName": recipe.recipeName,
            "recipeDescription": recipe.recipeDescription
        ]
        
        let imageDatas = images.compactMap { $0.jpegData(compressionQuality: 0.5) }
        
        return networkService.postRequest(
            url: url,
            parameters: parameters,
            imageDatas: imageDatas,
            responseType: NetworkResponseDTO<RecipeUploadResponseDTO>.self
        )
        .map { $0.data.toDomain() }
    }
}
