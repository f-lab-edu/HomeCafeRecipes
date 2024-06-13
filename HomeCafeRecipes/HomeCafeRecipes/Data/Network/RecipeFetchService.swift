//
//  RecipeFetchService.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 6/10/24.
//

import Foundation
import RxSwift

protocol RecipeFetchService {
    func fetchRecipes(pageNumber: Int) -> Single<[Recipe]>
    func searchRecipes(title: String, pageNumber: Int) -> Single<[Recipe]>
}

class DefaultRecipeFetchService: RecipeFetchService {
    private let networkService: NetworkService
    private let baseURL: URL
    
    init(networkService: NetworkService, baseURL: URL = URL(string: "https://meog0.store/api")!) {
        self.networkService = networkService
        self.baseURL = baseURL
    }
    
    func fetchRecipes(pageNumber: Int) -> Single<[Recipe]> {
        let url = baseURL.appendingPathComponent("recipes")
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = [URLQueryItem(name: "pageNumber", value: String(pageNumber))]
        guard let finalURL = urlComponents?.url else {
            return Single.error(NSError(domain: "URLComponentsError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }
        return networkService.getRequest(url: finalURL, responseType: NetworkResponseDTO<RecipePageDTO>.self)
            .map { responseDTO in
                return responseDTO.data.recipes.map { $0.toDomain() }
            }
    }
    
    func searchRecipes(title: String, pageNumber: Int) -> Single<[Recipe]> {
        let url = baseURL.appendingPathComponent("recipes")
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = [URLQueryItem(name: "keyword", value: title), URLQueryItem(name: "pageNumber", value: String(pageNumber))]
        guard let finalURL = urlComponents?.url else {
            return Single.error(NSError(domain: "URLComponentsError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }
        return networkService.getRequest(url: finalURL, responseType: NetworkResponseDTO<RecipePageDTO>.self)
            .map { responseDTO in
                return responseDTO.data.recipes.map { $0.toDomain() }
            }
    }
}
