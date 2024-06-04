//
//  FeedListRepository.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 5/30/24.
//

import Foundation

protocol FeedListRepository {
    func fetchFeedItems(completion: @escaping (Result<[FeedItem], Error>) -> Void)
    func searchFeedItems(title: String, completion: @escaping (Result<[FeedItem], Error>) -> Void)
}

final class FeedListRepositoryImpl: FeedListRepository {
    private let remoteDataSource: FirebaseRemoteDataSource
    
    init(remoteDataSource: FirebaseRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }
    
    func fetchFeedItems(completion: @escaping (Result<[FeedItem], Error>) -> Void) {
        remoteDataSource.fetchFeedItems(completion: completion)
    }
    
    func searchFeedItems(title : String, completion: @escaping (Result<[FeedItem], Error>) -> Void){
        remoteDataSource.searchFeedItems(title: title, completion: completion)
    }
}
