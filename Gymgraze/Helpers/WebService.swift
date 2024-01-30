//
//  WebService.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 30/01/2024.
//

import Foundation

// enum used for handlign different authentication errors
enum AuthenticationError: Error {
    case invalidCredentials
    case invalidURL
    case custom(errorMessage: String)
}

// struct used for encoding login request
struct LoginBody: Codable {
    var username: String
    var password: String
}

// struct used for decoding login response
struct LoginResponse: Codable {
    var token: String?
}

class WebService {
    /// Webservice login method is used for logging the user into the app
    /// - Parameters:
    ///   - username: user's username
    ///   - password: password
    ///   - completion: completion to be called after `login` finishes it's work
    func login(username: String, password: String, completion: @escaping (Result<String, AuthenticationError>) -> Void) {
        
        // construct the URL
        guard let url = URL(string: "https://something.com/login") else {
            // if it's not valid, throw a invalid URL error
            completion(.failure(AuthenticationError.invalidURL) as Result<String, AuthenticationError>)
            return
        }
        
        // construct the body
        let body = LoginBody(username: "superuser", password: "coolbeans")
        
        // create the request and set it's properties
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        // try to encode the body as JSON
        request.httpBody = try? JSONEncoder().encode(body)
        
        // create the data task
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // check if any data was received from the server
            guard let data = data, error == nil else {
                // return custom errro that there was no data received
                completion(.failure(AuthenticationError.custom(errorMessage: "No data was received from the server") as AuthenticationError))
                return
            }
            
            // try decode the response
            guard let loginResponse = try? JSONDecoder().decode(LoginResponse.self, from: data) else {
                // raise invalid credentials error
                completion(.failure(AuthenticationError.invalidCredentials) as Result<String, AuthenticationError>)
                return
            }
            
            // get the token from the response
            guard let token = loginResponse.token else {
                // if it's nil, raise invalid credentials error
                completion(.failure(AuthenticationError.invalidCredentials))
                return
            }
            
            // if everything went well, return the token
            completion(.success(token))
            
        }.resume()
        
    }
}
