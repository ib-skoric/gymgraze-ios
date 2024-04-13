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

/// Method used for getting and setting the token in the Keychain
func getAndSetTokenInKeychain(email: String, password: String, completion: @escaping (Result<Bool, APIError>) -> Void) {
    // use webservice to authenticate the user
    AuthenticationService().authenticate(email: email, password: password) { (result) in
        DispatchQueue.main.async {
            switch result {
            case .success(let token):
                let tokenData = token.data(using: .utf8)!
                let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                            kSecAttrAccount as String: "token",
                                            kSecValueData as String: tokenData]
                let status = SecItemAdd(query as CFDictionary, nil)
                if status == errSecSuccess {
                    print("Token saved successfully")
                    completion(.success(true))
                }
            case .failure(let error):
                print("Error authenticating: \(error)")
                completion(.failure(APIError.invalidCredentials))
            }
        }
    }
}

func checkTrendsCountSufficient(trend: [Double]) -> Bool {
    if trend.count >= 5 {
        return true
    }
    return false
}
