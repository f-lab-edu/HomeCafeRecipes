//
//  User.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 6/9/24.
//

import Foundation

struct User: Equatable {
    let id: Int
    let profileImage: String
    let nickname: String
    let createdAt: Date
}

extension User {
    static func dummyUser(
        id: Int = 1,
        profileImage: String = "",
        nickname: String = "testID",
        createAt: Date = Date()
    ) -> User {
        return User(
            id: id,
            profileImage: profileImage,
            nickname: nickname,
            createdAt: createAt
        )
    }
}
