//
//  NetworkService.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 6/12/24.
//

import Foundation
import RxSwift

protocol NetworkService {
    func getRequest<T: Decodable>(url: URL, responseType: T.Type) -> Single<T>
}

class BaseNetworkService: NetworkService {
    
    func getRequest<T: Decodable>(url: URL, responseType: T.Type) -> Single<T> {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return Single.create { single in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    single(.failure(error))
                } else if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .iso8601
                        let responseObject = try decoder.decode(T.self, from: data)
                        single(.success(responseObject))
                    } catch let decodingError {
                        single(.failure(decodingError))
                    }
                }
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
