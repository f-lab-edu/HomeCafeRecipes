//
//  FetchCommentUsecase.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 10/6/24.
//

import RxSwift

protocol FetchCommentUsecase{
    func execute(recipeID: Int) -> Single<[Comment]>
}


final class FetchCommentUsecaseImpl: FetchCommentUsecase{
    private let repository: CommentListRepository
    
    init(repository: CommentListRepository) {
        self.repository = repository
    }
    
    func execute(recipeID: Int) -> Single<[Comment]> {
        return repository.fetchComments(recipeID: recipeID)
    }
}
