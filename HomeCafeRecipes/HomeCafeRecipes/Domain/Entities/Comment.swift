//
//  Comment.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 10/5/24.
//

import Foundation

struct Comment {
    let commentID: Int
    let comment: String
    let commentLikeCount: Int
    let isLiked: Bool
    let createAt: Date
    let writer: User
}
