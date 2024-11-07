//
//  CommentInteractor.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 10/6/24.
//

import Foundation

import RxSwift

protocol CommentInteractorDelegate: AnyObject {
    func fetchedComments(result: Result<[Comment], Error>)
}

protocol CommentInteractor {
    func loadComment(recipeID: Int)
    func didEndEditing(comment: String)
    func addComment(recipeID: Int,comment: String) -> Single<Result<Comment, Error>>
}

final class CommentInteractorImpl: CommentInteractor {
    
    private let disposeBag = DisposeBag()
    private let fetchusecase: FetchCommentUsecase
    private let addusecase: AddCommentUseCase
    private var allComments: [Comment] = []
    private var comment: String = ""
    
    weak var delegate: CommentInteractorDelegate?
    
    init(
        fetchusecase: FetchCommentUsecase,
        addusecase: AddCommentUseCase
    ) {
        self.fetchusecase = fetchusecase
        self.addusecase = addusecase
    }
    
    func loadComment(recipeID: Int) {
        fetchusecase.execute(recipeID: recipeID)
            .subscribe(onSuccess: { [weak self] comments in
                self?.handleResult(.success(comments))
            }, onError: { [weak self] error in
                self?.handleResult(.failure(error))
            })
            .disposed(by: disposeBag)
    }
    
    private func handleResult(_ result: Result<[Comment], Error>) {
        switch result {
        case .success(let comments):
            if comments.isEmpty {
                return
            }
            allComments = comments
            delegate?.fetchedComments(result: .success(allComments))
        case .failure(let error):
            delegate?.fetchedComments(result: .failure(error))
        }
    }
    
    func didEndEditing(comment: String) {
        self.comment = comment
    }
    
    // MARK: userID 받아오는 작업 예정
    func addComment(
        recipeID: Int,
        comment: String
    ) -> Single<Result<Comment, Error>> {
        return addusecase.execute(
            recipeID: recipeID,
            userID: 1,
            comment: comment
        )
        .catch { error in            
            return .just(.failure(error))
        }
    }
}
