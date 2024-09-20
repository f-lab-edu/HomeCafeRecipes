//
//  SignUpError.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 9/8/24.
//

import Foundation

enum SignUpError: Error {
    case passwordMismatch
    case genericError(Error)    
}

extension SignUpError: LocalizedError {
    var title: String {
        switch self {
        case .passwordMismatch:
            return "비밀번호 불일치"
        case .genericError:
            return "회원가입 실패"
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .passwordMismatch:
            return "비밀번호를 확인해 주세요"
        case .genericError(let error):
            return error.localizedDescription
        }
    }
}
