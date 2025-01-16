//
//  KeychainRepository.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 1/16/25.
//

import Foundation

import Security

protocol KeychainRepository {
    func save(key: String, value: String)
    func load(key: String) -> String?
    func delete(key: String)
}

final class KeychainRepositoryImpl: KeychainRepository {
    func save(key: String, value: String) {
        let data = value.data(using: .utf8)!
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }
    
    func load(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var result: AnyObject?
        if SecItemCopyMatching(query as CFDictionary, &result) == noErr {
            if let data = result as? Data {
                return String(data: data, encoding: .utf8)
            }
        }
        return nil
    }
    
    func delete(key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        SecItemDelete(query as CFDictionary)
    }
}
