//
//  ServiceModels.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 14/02/2024.
//

import Foundation

/// enumeration used for handlign different authentication errors
enum APIError: Error {
    case invalidCredentials
    case invalidURL
    case serverDown
    case custom(errorMessage: String)
}

/// structure used for encoding login request
struct LoginBody: Codable {
    var email: String
    var password: String
}

/// structure used for decoding login response
struct LoginResponse: Codable {
    var token: String?
}
