//
//  SendVerificationCodeService.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 12/20/24.
//

import UIKit

import RxSwift

protocol SendVerificationCodeService {
    func checkVerifyCodeRequest(email: String) -> Single<Bool>
}

final class SendVerificationCodeServiceImpl: SendVerificationCodeService {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    private func makeURL(endpoint: String) -> URL {
        return APIConfig().baseURL.appendingPathComponent(endpoint)
    }
    
    func checkVerifyCodeRequest(email: String) -> Single<Bool> {
        let url = makeURL(endpoint: "verification/requestVerification")
        
        let parameters: [String: Any] = [
            "email": email,
        ]
        
        return networkService.postJsonRequest(
            url: url,
            parameters: parameters,
            responseType: NetworkResponseDTO<Bool>.self
        )
        .map{ $0.data }
    }
}
