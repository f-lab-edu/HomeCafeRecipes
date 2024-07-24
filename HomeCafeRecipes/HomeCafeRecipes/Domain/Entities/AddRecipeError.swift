//
//  AddRecipeError.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 7/17/24.
//

import Foundation

enum AddRecipeError: Error {
    case noImages
    case titleIsEmpty
    case descriptionTooShort
    case genericError(Error)
}

extension AddRecipeError: LocalizedError {
    
    var title: String {
        switch self {
        case .noImages:
            return "이미지 없음"
        case .titleIsEmpty:
            return "제목 없음"
        case .descriptionTooShort:
            return "설명 부족"
        case .genericError:
            return "업로드 실패"
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .noImages:
            return "최소 한 장의 이미지를 추가해 주세요."
        case .titleIsEmpty:
            return "제목을 입력해 주세요."
        case .descriptionTooShort:
            return "설명을 10자 이상 입력해 주세요."
        case .genericError(let error):
            return error.localizedDescription
        }
    }
}
