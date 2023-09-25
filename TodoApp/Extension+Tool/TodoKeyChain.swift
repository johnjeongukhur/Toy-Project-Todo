//
//  TodoKeyChain.swift
//  TodoApp
//
//  Created by John Hur on 2023/09/11.
//

import Foundation
import Kingfisher

class KeychainManager {
    static let shared = KeychainManager()
    
    private let keychain = TodoKeychain()

    private var _tokenKey: String = ""
    var tokenKey: String {
        get {
            if self._tokenKey.isEmpty {
                self._tokenKey = TodoKeychain().tokenKey() ?? ""
            }
            return self._tokenKey.isEmpty ? "" : "Bearer " + self._tokenKey
        }
        set(newVal) {
            self._tokenKey = newVal
            TodoKeychain().save(tokenKey: self._tokenKey)
        }
    }
    
    
    static func saveToken(token: String, forKey key: String) {
        guard let data = token.data(using: .utf8) else { return }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status != errSecSuccess {
            print("Error saving token to Keychain")
        }
    }
    
    static func getToken(forKey key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue as Any
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess {
            if let data = dataTypeRef as? Data,
               let token = String(data: data, encoding: .utf8) {
                return token
            }
        }
        
        return nil
    }
    
    static func deleteToken(forKey key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status != errSecSuccess {
            print("Error deleting token from Keychain")
        }
    }
}

fileprivate class TodoKeychain {
    let ACCOUNT_KEY = "co.TodoApp.account"
    
    func tokenKey() -> String? {
        return self.read(service: ACCOUNT_KEY, account: "tokenKey")
    }
    
    func save(tokenKey: String) {
        self.save(service: ACCOUNT_KEY, account: "tokenKey", value: tokenKey)
    }
    
    func deleteTokenKey() {
        self.delete(service: ACCOUNT_KEY, account: "tokenKey")
    }
    
    private func save(service: String, account: String, value: String) {
        let keyChainQuery: NSDictionary = [kSecClass: kSecClassGenericPassword,
                                           kSecAttrService: service,
                                           kSecAttrAccount: account,
                                           kSecValueData: value.data(using: .utf8, allowLossyConversion: false)!]
        
        SecItemDelete(keyChainQuery)
        
        let status: OSStatus = SecItemAdd(keyChainQuery, nil)
        assert(status == noErr, "저장 실패")
    }

    private func read(service: String, account: String) -> String? {
        let keyChainQuery: NSDictionary = [kSecClass: kSecClassGenericPassword,
                                           kSecAttrService: service,
                                           kSecAttrAccount: account,
                                           kSecReturnData: kCFBooleanTrue as Any,
                                           kSecMatchLimit: kSecMatchLimitOne]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(keyChainQuery, &dataTypeRef)
        guard status == errSecSuccess else {
            return nil
        }
        
        let retrievedData = dataTypeRef as! Data
        return String(data: retrievedData, encoding: .utf8)
    }
    
    private func delete(service: String, account: String) {
        let keyChainQuery: NSDictionary = [kSecClass: kSecClassGenericPassword,
                                           kSecAttrService: service,
                                           kSecAttrAccount: account]
        
        let status = SecItemDelete(keyChainQuery)
        assert(status == noErr, "token remove failure..")
    }

    
}
