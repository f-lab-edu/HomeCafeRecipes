//
//  SearchFeedUseCase.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 6/9/24.
//

import RxSwift

protocol SearchFeedListUseCase {
    func execute(title: String, currentPage: Int, targetPage: Int, boundaryID: Int) -> Single<Result<[Recipe], Error>>
}

class SearchFeedListUseCaseImpl: SearchFeedListUseCase {
    private let repository: SearchFeedListRepository

    init(repository: SearchFeedListRepository) {
        self.repository = repository
    }
    
    func execute(
        title: String,
        currentPage: Int,
        targetPage: Int,
        boundaryID: Int
    ) -> Single<Result<[Recipe], Error>> {
        return repository.searchRecipes(
            title: title,
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
