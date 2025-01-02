//
//  EmailVerificationCodeService.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 12/24/24.
//

import Foundation

import RxSwift

protocol EmailVerificationCodeService {
    func validateEmailCode(email:String, code:String) -> Single<Bool>
}

final class EmailVerificationCodeServiceImpl: EmailVerificationCodeService {
    private let network : BaseNetworkService
    
    init(network: BaseNetworkService) {
        self.network = network
    }
    
    private func makeURL(ednpoint: String) -> URL {
        return APIConfig().baseURL.appendingPathComponent(ednpoint)
    }
    
    func validateEmailCode(email: String, code: String) -> Single<Bool> {
        var components = URLComponents(url: makeURL(ednpoint: "verification/verifyCode"), resolvingAgainstBaseURL: false)
        components?.queryItems = [
            URLQueryItem(name: "email", value: email),
            URLQueryItem(name: "code", value: code)
        ]
        
        guard let urlWithQuery = components?.url else {
            return Single.error(NSError(domain: "Invalid URL", code: -1, userInfo: nil))
        }
        
        return network.postJsonRequest(
            url: urlWithQuery,
            parameters: [:],
            responseType: NetworkResponseDTO<Bool>.self
        )
        .map { $0.data }
    }
}
