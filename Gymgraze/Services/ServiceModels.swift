//
//  ServiceModels.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 14/02/2024.
//

import Foundation

/// Enumeration used for handlign different authentication errors
enum APIError: Error {
    case invalidCredentials
    case invalidURL
    case serverDown
    case custom(errorMessage: String)
}

/// Structure used for encoding login request
struct LoginBody: Codable {
    var email: String
    var password: String
}

/// Structure used for decoding login response
struct LoginResponse: Codable {
    var token: String?
}

struct confirmEmail: Codable {
    var confirmation_token: String
}

