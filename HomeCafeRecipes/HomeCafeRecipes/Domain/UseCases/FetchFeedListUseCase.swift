//
//  FetchFeedListUseCase.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 6/9/24.
//

import RxSwift

protocol FetchFeedListUseCase {
    func execute(currentPage: Int, targetPage: Int, boundaryID: Int) -> Single<Result<[Recipe], Error>>
}

class FetchFeedListUseCaseImpl: FetchFeedListUseCase {
    private let repository: FeedListRepository
    
    init(repository: FeedListRepository) {
        self.repository = repository
    }
    
    func execute(currentPage: Int, targetPage: Int, boundaryID: Int) -> Single<Result<[Recipe], Error>> {
        return repository.fetchRecipes(
            currentPage: currentPage,
            targetPage: targetPage,
            boundaryID: boundaryID
        )
        .map { recipes in
            return .success(recipes)
        }
        .catch { error in
            return .just(.failure(error))
        }
    }
}
