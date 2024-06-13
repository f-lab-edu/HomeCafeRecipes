//
//  FetchFeedListUseCase.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 6/9/24.
//

import RxSwift

protocol FetchFeedListUseCase {
    func execute(pageNumber: Int) -> Single<Result<[Recipe], Error>>
}

class DefaultFetchFeedListUseCase: FetchFeedListUseCase {
    private let repository: FeedListRepository
    
    init(repository: FeedListRepository) {
        self.repository = repository
    }
    
    func execute(pageNumber: Int) -> Single<Result<[Recipe], Error>> {
        return repository.fetchRecipes(pageNumber: pageNumber)
            .map { recipes in                
                return .success(recipes)
            }
            .catch { error in
                return .just(.failure(error))
            }
    }
}
