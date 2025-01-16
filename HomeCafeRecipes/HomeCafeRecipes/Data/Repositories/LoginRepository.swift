//
//  LoginRepository.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 8/31/24.
//

import Foundation

import RxSwift

protocol LoginRepository {
    func login(userID: String, password: String) -> Single<Result<LoginResponseDTO, LoginError>>
}

final class LoginRepositoryImpl: LoginRepository {
    
    private let loginService: LoginService
    
    init(loginService: LoginService) {
        self.loginService = loginService
    }
    
    func login(userID: String, password: String) -> Single<Result<LoginResponseDTO, LoginError>> {
        return loginService.login(userID: userID, password: password)
            .catch { error in                
                if let urlError = error as? URLError {
                    switch urlError.code {
                    case .notConnectedToInternet:
                        return .just(.failure(.genericError(
                            NSError(
                                domain: "Network",
                                code: -1009,
                                userInfo: [NSLocalizedDescriptionKey: "인터넷 연결이 필요합니다."]
                            )
                        )))
                    case .timedOut:
                        return .just(.failure(.genericError(
                            NSError(
                                domain: "Network",
                                code: -1001,
                                userInfo: [NSLocalizedDescriptionKey: "요청 시간이 초과되었습니다."]
                            )
                        )))
                    default:
                        return .just(.failure(.genericError(urlError)))
                    }
                }
                return .just(.failure(.genericError(error)))
            }
    }
}
