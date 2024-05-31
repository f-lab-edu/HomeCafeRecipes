//
//  fetchFeedListUsecase.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 5/30/24.
//


protocol FetchFeedListUseCase {
    func execute(completion: @escaping (Result<[FeedItem], Error>) -> Void)
}

class DefaultFetchFeedListUseCase: FetchFeedListUseCase {
    private let repository: FeedListRepository

    init(repository: FeedListRepository) {
        self.repository = repository
    }

    func execute(completion: @escaping (Result<[FeedItem], Error>) -> Void) {
        repository.fetchFeedItems { result in
            completion(result)
        }
    }
}
