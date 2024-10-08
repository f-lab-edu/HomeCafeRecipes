//
//  CommentListRepository.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 10/6/24.
//

import Foundation

import RxSwift

protocol CommentListRepository {
    func fetchComments(recipeID: Int) -> Single<[Comment]>
}

final class CommentListRepositoryImpl: CommentListRepository {
    private let commnetServie: CommentService
    
    init(commnetServie: CommentService) {
        self.commnetServie = commnetServie
    }
    
    func fetchComments(recipeID: Int) -> Single<[Comment]> {
        return commnetServie.fetchComment(recipeID: recipeID)
    }        
}
