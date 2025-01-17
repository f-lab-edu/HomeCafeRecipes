//
//  LoginResponseDTO.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 1/15/25.
//

import Foundation

struct LoginResponseDTO: Decodable {
    let accessToken: String
    let refreshToken: String
}

extension LoginResponseDTO {
    func toDomain() -> Token {
        return Token(
            accessToken: accessToken,
            refreshToken: refreshToken
        )
    }
}
