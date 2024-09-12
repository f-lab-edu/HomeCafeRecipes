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
        let url = makeURL(endpoint: "auth/register")
        
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
                // 성공 시 data가 null이더라도 성공 처리
                return .just(())
            } else {
                // statusCode가 200이 아니면 에러 처리
                return .error(NSError(domain: "SignUpError", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: response.message]))
            }
        }
        .catch { error in
            // 네트워크 또는 서버에서 에러가 발생했을 경우 처리
            return .error(error)
        }
    }
}
