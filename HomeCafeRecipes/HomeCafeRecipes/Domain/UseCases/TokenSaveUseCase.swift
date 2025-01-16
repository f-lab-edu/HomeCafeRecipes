//
//  TokenSaveUseCase.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 1/16/25.
//

import Foundation

protocol TokenSaveUseCase {
    func saveTokens(accessToken: String, refreshToken: String)
}

final class TokenSaveUseCaseImpl: TokenSaveUseCase {
    private let keychainRepository: KeychainRepository
    
    init(keychainRepository: KeychainRepository) {
        self.keychainRepository = keychainRepository
    }
    
    func saveTokens(accessToken: String, refreshToken: String) {
        keychainRepository.save(key: "accessToken", value: accessToken)
        keychainRepository.save(key: "refreshToken", value: refreshToken)
    }
}
