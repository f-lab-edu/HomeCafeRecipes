//
//  CommentService.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 10/6/24.
//

import UIKit

import RxSwift

protocol CommentService {
    func fetchComment(recipeID: Int) -> Single<[Comment]>
}

final class CommentServiceImpl: CommentService {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    private func makeURL(ednpoint: String) -> URL {
        return APIConfig().baseURL.appendingPathComponent(ednpoint)
    }
    
    func fetchComment(recipeID: Int) -> Single<[Comment]> {
        let url = makeURL(ednpoint: "comments/\(recipeID)")
        
        return networkService.getRequest(
            url: url,
            responseType: NetworkResponseDTO<[CommentDTO]>.self
        ).map { response in
            response.data.map { $0.toDomain() }            
        }
    }
}
