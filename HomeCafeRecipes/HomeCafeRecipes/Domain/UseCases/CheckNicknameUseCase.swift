//
//  CheckNicknameUseCase.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 1/6/25.
//

import RxSwift

protocol CheckNicknameUseCase {
    func execute(nickname: String) -> Single<Bool>
}

final class CheckNicknameUseCaseImpl: CheckNicknameUseCase {
    private let repository: CheckNicknameRepository
    
    init(repository: CheckNicknameRepository) {
        self.repository = repository
    }
    
    func execute(nickname: String) -> Single<Bool> {
        return repository.checkNicknameAvailability(nickname: nickname)
    }
}
