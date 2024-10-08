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
}

final class CommentInteractorImpl: CommentInteractor {
    private let disposeBag = DisposeBag()
    private let usecase: FetchCommentUsecase
    private var allComments: [Comment] = []
    weak var delegate: CommentInteractorDelegate?
    
    init(usecase: FetchCommentUsecase) {
        self.usecase = usecase
    }
    
    func loadComment(recipeID: Int) {
        usecase.execute(recipeID: recipeID)
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
}
