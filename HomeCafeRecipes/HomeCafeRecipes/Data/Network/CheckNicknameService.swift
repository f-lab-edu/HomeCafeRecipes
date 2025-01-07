//
//  CheckNicknameService.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 1/6/25.
//

import Foundation

import RxSwift

protocol CheckNicknameService {
    func checkNickname(nickname: String) -> Single<Bool>
}

final class CheckNicknameServiceImpl: CheckNicknameService {
    private let network : BaseNetworkService
    
    init(network: BaseNetworkService) {
        self.network = network
    }
    
    private func makeURL(ednpoint: String) -> URL {
        return APIConfig().baseURL.appendingPathComponent(ednpoint)
    }
    
    func checkNickname(nickname: String) -> Single<Bool> {
        var components = URLComponents(url: makeURL(ednpoint: "verification/checkNickname"), resolvingAgainstBaseURL: false)
        components?.queryItems = [
            URLQueryItem(name: "nickname", value: nickname),
        ]
        
        guard let urlWithQuery = components?.url else {
            return Single.error(NSError(domain: "Invalid URL", code: -1, userInfo: nil))
        }
        
        return network.getRequest(
            url: urlWithQuery,
            responseType: NetworkResponseDTO<CheckNicknameDTO>.self
        )
        .map { $0.data.isDuplicate }
        .do(onSuccess: { isDuplicate in
            print("Is Duplicate: \(isDuplicate)")
            print(nickname)
        }, onError: { error in
            print("Error occurred: \(error.localizedDescription)")
        })
    }
}
