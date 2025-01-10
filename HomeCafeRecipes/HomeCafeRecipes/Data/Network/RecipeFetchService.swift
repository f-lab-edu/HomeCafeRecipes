//
//  RecipeFetchService.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 6/10/24.
//

import Foundation
import RxSwift

protocol RecipeFetchService {
    func fetchRecipes(currentPage: Int, targetPage: Int, boundaryID: Int) -> Single<[Recipe]>
    func searchRecipes(title: String, pageNumber: Int) -> Single<[Recipe]>
}

class RecipeFetchServiceImpl: RecipeFetchService {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    private func makeURL(endpoint: String, queryItems: [URLQueryItem]) -> URL? {
        let URL = APIConfig().baseURL.appendingPathComponent(endpoint)
        var URLComponents = URLComponents(url: URL, resolvingAgainstBaseURL: false)
        URLComponents?.queryItems = queryItems
        return URLComponents?.url
    }
    
    private func makeQueryItems(
        currentPage: Int,
        targetPage: Int,
        boundaryID: Int,
        keyword: String? = nil
    ) -> [URLQueryItem] {
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "currentPage", value: String(currentPage)),
            URLQueryItem(name: "targetPage", value: String(targetPage)),
            URLQueryItem(name: "boundaryId", value: String(boundaryID))
        ]
        
        if let keyword = keyword, !keyword.isEmpty {
            queryItems.append(URLQueryItem(name: "keyword", value: keyword))
        }
        
        return queryItems
    }
    
    func fetchRecipes(
        currentPage: Int,
        targetPage: Int,
        boundaryID: Int
    ) -> Single<[Recipe]> {
        let queryItems = makeQueryItems(
            currentPage: currentPage,
            targetPage: targetPage,
            boundaryID: boundaryID
        )
        
        guard let URL = makeURL(endpoint: "recipes", queryItems: queryItems) else {
            return Single.error(NSError(
                domain: "URLComponentsError",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }
        
        return networkService.getRequest(url: URL, responseType: NetworkResponseDTO<RecipePageDTO>.self)
            .map { $0.data.recipes.map { $0.toDomain() } }
    }
    
    func searchRecipes(title: String, pageNumber: Int) -> Single<[Recipe]> {
        guard let URL = makeURL(endpoint: "recipes", queryItems: [
            URLQueryItem(
                name: "keyword",
                value: title
            ),
            URLQueryItem(
                name: "pageNumber",
                value: String(pageNumber)
            )
        ]) else {
            return Single.error(
                NSError(
                    domain: "URLComponentsError",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
        }
        return networkService.getRequest(
            url: URL, responseType:
                NetworkResponseDTO<RecipePageDTO>.self
        )
        .map { $0.data.recipes.map{ $0.toDomain() } }
    }
}
