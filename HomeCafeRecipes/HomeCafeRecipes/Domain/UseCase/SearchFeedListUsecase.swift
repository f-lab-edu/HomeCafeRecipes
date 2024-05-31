//
//  SearchFeedListusecase.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 5/30/24.
//


protocol SearchFeedListUseCase {
    func execute(title: String, completion: @escaping (Result<[FeedItem], Error>) -> Void)
}

class DefaultSearchFeedListUseCase: SearchFeedListUseCase {
    private let repository: FeedListRepository

    init(repository: FeedListRepository) {
        self.repository = repository
    }

    func execute(title: String, completion: @escaping (Result<[FeedItem], Error>) -> Void) {
        repository.searchFeedItems(title: title) { result in
            completion(result)
        }
    }
}
