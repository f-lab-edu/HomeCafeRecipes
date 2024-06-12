//
//  SearchFeedListRepository.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 6/10/24.
//

import RxSwift

protocol SearchFeedListRepository {
    func searchRecipes(title: String, pageNumber: Int) -> Single<[Recipe]>
}

class DefaultSearchFeedRepository: SearchFeedListRepository {
            
    private let networkService: RecipeFetchService
    
    init(networkService: RecipeFetchService) {
        self.networkService = networkService
    }
    
    func searchRecipes(title: String,pageNumber: Int) -> Single<[Recipe]> {
        return networkService.searchRecipes(title: title, pageNumber: pageNumber)
    }
}
