//
//  CommnetMapper.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 10/8/24.
//

import Foundation

struct CommentMapper {    
    static func mapToViewModels(from comments: [Comment]) -> [CommentViewModel] {
        return comments.map { CommentViewModel(comment: $0) }
    }
    
}
