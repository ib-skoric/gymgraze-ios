//
//  Helpers.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 14/02/2024.
//

import Foundation

func getToken() -> String? {
    /// Function used to get the token from the keychain
    
    // create the query
    let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                kSecAttrAccount as String: "token",
                                kSecMatchLimit as String: kSecMatchLimitOne,
                                kSecReturnData as String: kCFBooleanTrue!]
    
    // create a reference to the data
    var dataTypeRef: AnyObject?
    // execute the query
    let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
    
    // check if the query was successful (no errro)
    if status == noErr {
        if let data = dataTypeRef as? Data {
            // return the token as a string
            return String(data: data, encoding: .utf8)
        }
    }
    // if there was an error, return nil
    return nil
}
