//
//  LoginService.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 8/31/24.
//

import Foundation

import RxSwift

protocol LoginService {
    func login(userID: String, password: String) -> Single<Result<LoginResponseDTO, LoginError>>
}

final class LoginServiceImpl: LoginService {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    private func makeURL(ednpoint: String) -> URL {
        return APIConfig().baseURL.appendingPathComponent(ednpoint)
    }
    
    func login(userID: String, password: String) -> Single<Result<LoginResponseDTO, LoginError>> {
        let url = makeURL(ednpoint: "auth/login")
        
        let parameters: [String: Any] = [
            "email": userID,
            "password": password,
        ]
        
        return networkService.postJsonRequest(
            url: url,
            parameters: parameters,
            responseType: NetworkResponseDTO<LoginResponseDTO>.self
        )        
        .map { response in
            if response.statusCode == 200 {
                return .success(response.data)
            } else {
                return .failure(.serverError(response.message))
            }
        }
        .catch { error in
                .just(.failure(.genericError(error)))
        }
    }
}
