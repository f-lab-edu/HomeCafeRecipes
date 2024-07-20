//
//  NetworkService.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 6/12/24.
//

import Foundation
import UIKit

import RxSwift

protocol NetworkService {
    func getRequest<T: Decodable>(url: URL, responseType: T.Type) -> Single<T>
    func postRequest<T: Decodable>(url: URL, parameters: [String: Any], imageDatas: [Data], responseType: T.Type) -> Single<T>
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
    
    func postRequest<T: Decodable>(
        url: URL, parameters: [String: Any],
        imageDatas: [Data],
        responseType: T.Type
    )
    -> Single<T> {
        return Single.create { single in
            var formDataRequest = MultipartFormDataRequest(url: url)
            
            for (key, value) in parameters {
                formDataRequest.addTextField(named: key, value: String(describing: value))
            }
            
            for (index, imageData) in imageDatas.enumerated() {
                let filename = "image\(index).jpg"
                formDataRequest.addDataField(
                    named: "recipeImgUrls",
                    data: imageData,
                    filename: filename,
                    mimeType: "image/jpeg"
                )
            }
            
            formDataRequest.finalize()
            let request = formDataRequest.asURLRequest()
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    single(.failure(error))
                } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                    let statusCode = httpResponse.statusCode
                    let responseString = data.flatMap { String(data: $0, encoding: .utf8) } ?? "No response data"
                    let error = NSError(
                        domain: "",
                        code: statusCode,
                        userInfo: [NSLocalizedDescriptionKey: "HTTP \(statusCode): \(responseString)"]
                    )
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
