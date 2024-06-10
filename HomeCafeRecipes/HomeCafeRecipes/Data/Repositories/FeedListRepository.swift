//
//  FeedListRepository.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 6/10/24.
//

import RxSwift

protocol FeedListRepository {
    func fetchRecipes() -> Observable<[Recipe]>
}

class DefaultFeedListRepository: FeedListRepository {
    private let networkService: RecipeFetchService

    init(networkService: RecipeFetchService) {
        self.networkService = networkService
    }

    func fetchRecipes() -> Observable<[Recipe]> {
        return networkService.fetchRecipes()
    }
}
