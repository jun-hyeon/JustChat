//
//  KeyChainManager.swift
//  JustChat
//
//  Created by 최준현 on 7/31/24.
//

import Foundation
import Security



class KeyChainManager{
    static let shared = KeyChainManager()
    private let service = "tokens"
    
    func storeData(token: String, forAccount account: String)->Bool{
        let keyChainItem = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecAttrService: service,
            kSecValueData: token.data(using: .utf8) as Any
        ] as [String : Any]
        
        let status = SecItemAdd(keyChainItem as CFDictionary, nil)
        guard status == errSecSuccess else{
            print("Keychain create Error")
            return false
        }
        return true
    }
    
     func read(forAccount account: String) -> String?{
        let keychainItem = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecAttrService: service,
            kSecReturnData: true
        ] as [String : Any]
        
        var item: AnyObject?
        let status = SecItemCopyMatching(keychainItem as CFDictionary, &item)
        if status == errSecSuccess{
            return String(data: item as! Data, encoding: .utf8)
        }
        
        if status == errSecItemNotFound{
            print("The token was not found in keychain")
            return nil
        }else{
            print("Error getting token from keychain: \(status)")
            return nil
        }
    }
    
    func update(token: String, forAccount account: String) -> Bool{
        let keychainItem = [
            kSecClass: kSecClassGenericPassword
        ] as [String : Any]
        
        let attributes = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecValueData: token.data(using: .utf8) as Any
        ]
        
        let status = SecItemUpdate(keychainItem as CFDictionary, attributes as CFDictionary)
        guard status != errSecItemNotFound else{
            print("The token was not found in keychain")
            return false
        }
        
        guard status == errSecSuccess else{
            print("keychain update error")
            return false
        }
        
        print("The token in keychain is updated")
        return true
    }
    
    func delete(forAccount account: String) -> Bool{
        let keychainItem = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account
        ] as [String : Any]
        
        let status = SecItemDelete(keychainItem as CFDictionary)
        guard status != errSecItemNotFound else{
            print("The token was not found in keychain")
            return false
        }
        guard status == errSecSuccess else{
            print("keychain delete Error")
            return false
        }
        
        print("The token in keychain is deleted")
        return true
    }
}
