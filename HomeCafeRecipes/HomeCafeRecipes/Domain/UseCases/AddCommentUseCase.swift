//
//  AddCommentUseCase.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 11/4/24.
//

import Foundation

import RxSwift

protocol AddCommentUseCase {
    func execute(
        recipeID: Int,
        userID: Int,
        comment: String
    ) -> Single<Result<Comment,Error>>
}

final class AddCommentUseCaseImpl : AddCommentUseCase {
    private let addcommentRepository: AddCommentRepository
    
    init(addcommentRepository: AddCommentRepository) {
        self.addcommentRepository = addcommentRepository
    }
    
    func execute(
        recipeID: Int,
        userID: Int,
        comment: String) -> Single<Result<Comment,Error>> {
            return addcommentRepository.addComment(
                recipeID: recipeID,
                userID: userID,
                comment: comment
            )
            .map{ .success($0) }
        }
}
