//
//  UserDTO.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 6/13/24.
//

import Foundation

struct UserDTO: Decodable {
    let userId: Int
    let nickname: String
    let profileImgUrl: String?
    
    func toDomain() -> User {
        return User(
            id: userId,
            profileImage: profileImgUrl ?? "", 
            nickname: nickname,
            createdAt: Date()
        )
    }
}
