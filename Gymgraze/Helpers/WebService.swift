//
//  WebService.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 30/01/2024.
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

class WebService {
    /// Webservice login method is used for logging the user into the app
    /// - Parameters:
    ///   - username: user's username
    ///   - password: password
    ///   - completion: completion to be called after `login` finishes it's work
    func authenticate(email: String, password: String, completion: @escaping (Result<String, APIError>) -> Void) {
        
        // construct the URL
        guard let url = URL(string: "http://localhost:3000/authenticate") else {
            // if it's not valid, throw a invalid URL error
            completion(.failure(APIError.invalidURL) as Result<String, APIError>)
            return
        }
        
        /// construct the body
        let body = LoginBody(email: email, password: password)
        
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
                completion(.failure(APIError.serverDown) as Result<String, APIError>)
                return
            }
            
            // check the status code of the response
            if let httpResonse = response as? HTTPURLResponse {
                switch httpResonse.statusCode {
                    // if the status code is 200
                case 200:
                    // try decode the response
                    guard let loginResponse = try? JSONDecoder().decode(LoginResponse.self, from: data) else {
                        // raise invalid credentials error
                        completion(.failure(APIError.invalidCredentials) as Result<String, APIError>)
                        return
                    }
                    
                    // get the token from the response
                    guard let token = loginResponse.token else {
                        // if it's nil, raise invalid credentials error
                        completion(.failure(APIError.invalidCredentials))
                        return
                    }
                    
                    // if everything went well, return the token
                    completion(.success(token))
                case 401:
                    // if the status code is 401, raise invalid credentials error
                    completion(.failure(APIError.invalidCredentials) as Result<String, APIError>)
                    
                default:
                    // if the status code is not 200 or 401, raise custom error with the status code
                    completion(.failure(APIError.custom(errorMessage: "Status code: \(httpResonse.statusCode)")) as Result<String, APIError>)
                }
            }
            
        }.resume()
        
    }
    
    func register(registration: Registration, completion: @escaping (Result<String, APIError>) -> Void) {
        
        // construct the URL
        guard let url = URL(string: "http://localhost:3000/user") else {
            // if it's not valid, throw a invalid URL error
            completion(.failure(APIError.invalidURL) as Result<String, APIError>)
            return
        }
        
        /// construct the body
        let body = registration
        
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
                completion(.failure(APIError.serverDown) as Result<String, APIError>)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse {
                switch httpStatus.statusCode {
                case 201:
                    // try decode the response
                    guard let registrationResponse = try? JSONDecoder().decode(User.self, from: data) else {
                        // raise invalid credentials error
                        completion(.failure(APIError.custom(errorMessage: "Something went wrong, please try again later") as APIError))
                        return
                    }
                    
                    // see if the response contains a email of the new user
                    let email = registrationResponse.email
                    
                    // if everything went well, return the email
                    print(email)
                    
                    completion(.success(email))
                default:
                    // if the status code is not 200 or 401, raise custom error with the status code
                    completion(.failure(APIError.custom(errorMessage: "Status code: \(httpStatus.statusCode)")) as Result<String, APIError>)
                }
            }
        }.resume()
    }
}
