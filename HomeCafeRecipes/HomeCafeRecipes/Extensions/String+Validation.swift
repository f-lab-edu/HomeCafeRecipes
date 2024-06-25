//
//  String+Validation.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 6/25/24.
//

import Foundation

extension String {
    var isBlank: Bool {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
