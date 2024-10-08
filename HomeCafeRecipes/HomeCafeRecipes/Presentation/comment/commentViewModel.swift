//
//  commentViewModel.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 10/5/24.
//

import Foundation

struct CommentViewModel {
    let username: String
    let profileImgUrl: URL?
    let comment : String
    let commentLikeCnt: Int
    let date: Date
    let isLiked: Bool
    
    init(comment: Comment) {
        self.username = comment.writer.nickname
        self.profileImgUrl = URL(string: comment.writer.profileImage)
        self.comment = comment.comment
        self.commentLikeCnt = comment.commentLikeCount
        self.date = comment.createAt
        self.isLiked = comment.isLiked
    }
}
