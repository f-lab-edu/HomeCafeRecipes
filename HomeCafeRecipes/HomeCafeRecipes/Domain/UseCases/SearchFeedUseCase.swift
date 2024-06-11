//
//  SearchFeedUseCase.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 6/9/24.
//

import RxSwift

protocol SearchFeedListUseCase {
    func execute(title: String) -> Single<Result<[Recipe], Error>>
}

class DefaultSearchFeedListUseCase: SearchFeedListUseCase {
    private let repository: SearchFeedListRepository

    init(repository: SearchFeedListRepository) {
        self.repository = repository
    }

    func execute(title: String) -> Single<Result<[Recipe], Error>> {
        return repository.searchRecipes(title: title)
            .map { recipes in
                return .success(recipes)
            }
            .catch { error in
                return .just(.failure(error))
            }
    }
}
