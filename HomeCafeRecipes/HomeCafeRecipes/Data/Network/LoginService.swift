//
//  LoginService.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 8/31/24.
//

import Foundation

import RxSwift

protocol LoginService {
    func login(userID: String, password: String) -> Single<User>
}

final class LoginServiceImpl: LoginService {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    private func makeURL(ednpoint: String) -> URL {
        return APIConfig().baseURL.appendingPathComponent(ednpoint)
    }
    
    func login(userID: String, password: String) -> Single<User> {
        let url = makeURL(ednpoint: "auth/login")
        
        let parameters: [String: Any] = [
            "email": userID,
            "password": password,
            "nickname": ""
        ]
        
        return networkService.postRequest(
            url: url,
            parameters: parameters,
            imageDatas: [],
            responseType: NetworkResponseDTO<UserDTO>.self
        )
        .map { $0.data.toDomain() }
    }
}
