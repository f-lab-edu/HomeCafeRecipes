//
//  CommentPostService.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 11/4/24.
//

import Foundation

import RxSwift

protocol CommentPostService {
    func postComment(
        recipeID: Int,
        userID: Int,
        comment: String
    ) -> Single<Comment>
}

final class CommentPostServiceImpl: CommentPostService {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    private func makeURL(ednpoint: String) -> URL {
        return APIConfig().baseURL.appendingPathComponent(ednpoint)
    }
    
    func postComment(recipeID: Int, userID: Int, comment: String) -> Single<Comment> {
        let url = makeURL(ednpoint: "comments")
        
        let parameters: [String: Any] = [
            "userId": userID,
            "recipeId": recipeID,
            "content": comment
        ]
                    
        return networkService.postJsonRequest(
            url: url,
            parameters: parameters,
            responseType: NetworkResponseDTO<CommentDTO>.self
        )
        .flatMap { response in
            guard response.statusCode == 200 else {
                let error = NSError(
                    domain: "CommentPostServiceError",
                    code: response.statusCode,
                    userInfo: [NSLocalizedDescriptionKey: response.message]
                )
                return .error(error)
            }
            return .just(response.data.toDomain())
        }
    }
}
