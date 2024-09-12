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
    func postJsonRequest<T: Decodable>(url: URL, parameters:[String: Any], responseType: T.Type) -> Single<T>
}

final class BaseNetworkService: NetworkService {
    private func createRequest<T: Decodable>(with request: URLRequest, responseType: T.Type) -> Single<T> {
        return Single.create { single in
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

    func getRequest<T: Decodable>(url: URL, responseType: T.Type) -> Single<T> {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return createRequest(with: request, responseType: responseType)
    }
    
    func postRequest<T: Decodable>(
        url: URL, parameters: [String: Any],
        imageDatas: [Data],
        responseType: T.Type
    ) -> Single<T> {
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
        return createRequest(with: request, responseType: responseType)
    }
    
    func postJsonRequest<T: Decodable>(
        url: URL,
        parameters: [String: Any],
        responseType: T.Type
    ) -> Single<T> {
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return .error(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "JSON 인코딩 실패"]))
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = httpBody
        
        return createRequest(with: request, responseType: responseType)
    }
}
