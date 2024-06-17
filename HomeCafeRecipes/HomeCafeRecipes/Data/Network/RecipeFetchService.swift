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
    private static let baseURL: URL = URL(string: "https://meog0.store/api")!
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    private func buildURL(endpoint: String, queryItems: [URLQueryItem]) -> URL? {
        let URL = DefaultRecipeFetchService.baseURL.appendingPathComponent(endpoint)
        var URLComponents = URLComponents(url: URL, resolvingAgainstBaseURL: false)
        URLComponents?.queryItems = queryItems
        return URLComponents?.url
    }
    
    func fetchRecipes(pageNumber: Int) -> Single<[Recipe]> {
        guard let URL = buildURL(endpoint: "recipes", queryItems: [URLQueryItem(name: "pageNumber", value: String(pageNumber))]) else {
            return Single.error(NSError(domain: "URLComponentsError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }
        return networkService.getRequest(url: URL, responseType: NetworkResponseDTO<RecipePageDTO>.self)
            .map { $0.data.recipes.map{ $0.toDomain() } }
    }
    
    
    func searchRecipes(title: String, pageNumber: Int) -> Single<[Recipe]> {
        guard let URL = buildURL(endpoint: "recipes", queryItems: [
            URLQueryItem(name: "keyword", value: title),
            URLQueryItem(name: "pageNumber", value: String(pageNumber))
        ]) else {
            return Single.error(NSError(domain: "URLComponentsError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }
        return networkService.getRequest(url: URL, responseType: NetworkResponseDTO<RecipePageDTO>.self)
            .map { $0.data.recipes.map{ $0.toDomain() } }
    }
}
