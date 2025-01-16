//
//  SignUpService.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 9/11/24.
//

import Foundation

import RxSwift

protocol SignUpService {
    func signUp(
        userNickName: String,
        userID: String,
        password: String
    ) -> Single<Void>    
}

final class SignUpServiceImpl: SignUpService {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    private func makeURL(endpoint: String) -> URL {
        return APIConfig().baseURL.appendingPathComponent(endpoint)
    }
    
    func signUp(
        userNickName: String,
        userID: String,
        password: String
    ) -> Single<Void> {
        let url = makeURL(endpoint: "auth/signup")
        
        let parameters: [String: Any] = [
            "email": userID,
            "password": password,
            "nickname": userNickName
        ]
        
        return networkService.postJsonRequest(
            url: url,
            parameters: parameters,
            responseType: NetworkResponseDTO<EmptyResponse>.self
        )
        .flatMap { response in
            if response.statusCode == 200 {
                return .just(())
            } else {
                return .error(NSError(domain: "SignUpError", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: response.message]))
            }
        }
        .catch { error in
            return .error(error)
        }
    }
}
