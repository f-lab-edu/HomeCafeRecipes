//
//  FirebaseRemoteDataSource.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 5/30/24.
//

import FirebaseFirestore

class FirebaseRemoteDataSource {
    private let firebasedb = Firestore.firestore()
    
    func fetchFeedItems(completion: @escaping (Result<[FeedItem], Error>) -> Void) {
        firebasedb.collection("feedItems").getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let documents = querySnapshot?.documents else {
                completion(.success([]))
                return
            }
            let feedItems = documents.compactMap { doc -> FeedItem? in
                let data = doc.data()
                guard
                    let id = data["id"] as? String,
                    let title = data["title"] as? String,
                    let imageURLs = data["imageURLs"] as? [String] else {
                    return nil
                }
                return FeedItem(id: id, title: title, imageURLs: imageURLs)
                
            }
            completion(.success(feedItems))
        }
    }

    func searchFeedItems(title: String, completion: @escaping (Result<[FeedItem], Error>) -> Void) {
        firebasedb.collection("feedItems")
            .whereField("title", isGreaterThanOrEqualTo: title)
            .whereField("title", isLessThanOrEqualTo: "\(title)\u{f8ff}")
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let documents = querySnapshot?.documents else {
                    completion(.success([]))
                    return
                }
                let feedItems = documents.compactMap { doc -> FeedItem? in
                    let data = doc.data()
                    guard
                        let id = data["id"] as? String,
                        let title = data["title"] as? String,
                        let imageURLs = data["imageURLs"] as? [String] else {
                        return nil
                    }
                    return FeedItem(id: id, title: title, imageURLs: imageURLs)
                }
                completion(.success(feedItems))
            }
    }

}


