//
//  FeedListRepository.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 6/10/24.
//

import RxSwift

protocol FeedListRepository {
    func fetchRecipes() -> Single<[Recipe]>
}

class DefaultFeedListRepository: FeedListRepository {
    private let networkService: RecipeFetchService

    init(networkService: RecipeFetchService) {
        self.networkService = networkService
    }

    func fetchRecipes() -> Single<[Recipe]> {
        return networkService.fetchRecipes()
    }
}
