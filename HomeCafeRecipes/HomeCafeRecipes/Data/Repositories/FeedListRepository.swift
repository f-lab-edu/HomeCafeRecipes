//
//  FeedListRepository.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 6/10/24.
//

import RxSwift

protocol FeedListRepository {
    func fetchRecipes(currentPage: Int, targetPage: Int, boundaryID: Int) -> Single<[Recipe]>
}

class FeedListRepositoryImpl: FeedListRepository {
    private let networkService: RecipeFetchService

    init(networkService: RecipeFetchService) {
        self.networkService = networkService
    }

    func fetchRecipes(currentPage: Int, targetPage: Int, boundaryID: Int) -> Single<[Recipe]> {
        return networkService.fetchRecipes(currentPage: currentPage, targetPage: targetPage, boundaryID: boundaryID)
    }
}
