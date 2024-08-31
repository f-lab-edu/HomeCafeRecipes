//
//  LoginError.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 8/30/24.
//

import Foundation

enum LoginError: Error {
    case IDIsEmpty
    case passwordIsEmpty
    case genericError(Error)
}

extension LoginError: LocalizedError {
    
    var title: String {
        switch self {
        case .IDIsEmpty:
            return "아이디 없음"
        case .passwordIsEmpty:
            return "비밀번호 없음"
        case .genericError:
            return "로그인 실패"
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .IDIsEmpty:
            return "아이디를 입력해 주세요"
        case .passwordIsEmpty:
            return "비밀번호를 입력해 주세요"
        case .genericError(let error):
            return error.localizedDescription
        }
    }
}
