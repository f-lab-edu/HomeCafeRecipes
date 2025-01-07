//
//  CheckNicknameRepository.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 1/6/25.
//

import RxSwift

protocol CheckNicknameRepository {
    func checkNicknameAvailability(nickname: String) -> Single<Bool>
}

// Repository Implementation
final class CheckNicknameRepositoryImpl: CheckNicknameRepository {
    private let service: CheckNicknameService
    
    init(service: CheckNicknameService) {
        self.service = service
    }
    
    func checkNicknameAvailability(nickname: String) -> Single<Bool> {
        return service.checkNickname(nickname: nickname)
    }
}
