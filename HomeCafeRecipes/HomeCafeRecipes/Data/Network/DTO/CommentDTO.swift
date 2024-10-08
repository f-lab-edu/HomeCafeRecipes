//
//  CommentDTO.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 10/6/24.
//

import Foundation

struct CommentDTO: Decodable {
    
    let commentID: Int
    let comment: String
    let commentLikeCount: Int
    let isLiked: Bool
    let createdAt: String
    let writer: UserDTO
    
    enum CodingKeys: String, CodingKey {
        case commentID = "commentId"
        case comment = "content"
        case commentLikeCount = "commentLikesCnt"
        case isLiked = "isLiked"
        case createdAt = "createdAt"
        case writer = "writer"
    }
}

extension CommentDTO {
    func toDomain() -> Comment{
        return Comment (
            commentID: commentID,
            comment: comment,
            commentLikeCount: commentLikeCount,
            isLiked: isLiked,
            createAt: DateFormatter.iso8601.date(from: createdAt) ?? Date(),
            writer: writer.toDomain()
        )
        
    }
}
