//
//  AddCommentRepository.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 11/4/24.
//

import Foundation

import RxSwift

protocol AddCommentRepository {
    func addComment(
        recipeID: Int,
        userID: Int,
        comment: String
    ) -> Single<Comment>
}

final class AddCommenRepositoryImpl: AddCommentRepository {
    private let service: CommentPostService
    
    init(service: CommentPostService) {
        self.service = service
    }
    
    func addComment(recipeID: Int, userID: Int, comment: String) -> Single<Comment> {
        return service.postComment(recipeID: recipeID, userID: userID, comment: comment)
    }
}
