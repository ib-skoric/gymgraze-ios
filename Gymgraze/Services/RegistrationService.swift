//
//  WebService.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 30/01/2024.
//

import Foundation

/// Service that handles all calles to Rails back end associated with registering a user
class RegistrationService {
    /// Method used for registering the user
    /// - Parameters:
    ///   - registration: Registration object containing the user's data
    ///   - completion: completion handler that returns the result of the registration
    func register(registration: Registration, completion: @escaping (Result<String, APIError>) -> Void) {
        
        // construct the URL
        guard let url = URL(string: "http://localhost:3000/user") else {
            // if it's not valid, throw a invalid URL error
            completion(.failure(APIError.invalidURL) as Result<String, APIError>)
            return
        }
        
        // construct the body
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
                    print(email!)
                    
                    completion(.success(email!))
                default:
                    // if the status code is not 200 or 401, raise custom error with the status code
                    completion(.failure(APIError.custom(errorMessage: "Status code: \(httpStatus.statusCode)")) as Result<String, APIError>)
                }
            }
        }.resume()
    }
    
    /// Method used for checking if the current user's email address is confirmed or not
    /// - Parameter completion: completion to be called after `checkEmailConfirmed` finishes it's work
    func checkEmailConfirmed(completion: @escaping (Result<String, APIError>) -> Void) {
        
        // get the token for the currently logged in user
        let token: String? = getToken()
        
        // construct the URL
        guard let url = URL(string: "http://localhost:3000/user") else {
            // if it's not valid, throw a invalid URL error
            completion(.failure(APIError.invalidURL) as Result<String, APIError>)
            return
        }
        
        // create the request and set it's properties
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        // pass in the token in the headers for this request
        request.addValue("Bearer \(token ?? "no value")", forHTTPHeaderField: "Authorization")
        
        
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
                    guard let user = try? JSONDecoder().decode(User.self, from: data) else {
                        // raise invalid credentials error
                        completion(.failure(APIError.invalidCredentials) as Result<String, APIError>)
                        return
                    }
                    
                    // get the token from the response
                    guard let emailConfirmed = user.confirmed_at else {
                        // if it's nil, raise invalid credentials error
                        completion(.failure(APIError.invalidCredentials))
                        return
                    }
                    
                    // if everything went well, return the status
                    completion(.success(emailConfirmed))
                    print(emailConfirmed)
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
    
    /// Method used for confirming the user's email address
    func confirmEmail(confirmationToken: String, completion: @escaping (Result<String, APIError>) -> Void) {
        // get the token for the currently logged in user
        let token: String? = getToken()
        
        // construct the URL
        guard let url = URL(string: "http://localhost:3000/confirm_email") else {
            // if it's not valid, throw a invalid URL error
            completion(.failure(APIError.invalidURL) as Result<String, APIError>)
            return
        }
        
        // construct the body as JSON
        let body = ["confirmation_token": confirmationToken]
        
        // create the request and set it's properties
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        // pass in the token in the headers for this request
        request.addValue("Bearer \(token ?? "no value")", forHTTPHeaderField: "Authorization")
        // try to encode the body as JSON
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            print("Error encoding JSON: \(error)")
        }
        
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
                case 202:
                    // try decode the response
                    guard let user = try? JSONDecoder().decode(User.self, from: data) else {
                        // raise invalid credentials error
                        completion(.failure(APIError.invalidCredentials) as Result<String, APIError>)
                        return
                    }
                    
                    print(user)
                    
                    // get the timestamp of confirmation from the response
                    guard let emailConfirmedTimestamp = user.confirmed_at else {
                        // if it's nil, raise invalid credentials error
                        completion(.failure(APIError.invalidCredentials))
                        return
                    }
                    
                    // if everything went well, return the timestamp
                    completion(.success(emailConfirmedTimestamp))
                    print(emailConfirmedTimestamp)
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
    
    func resendEmailConfirmation(completion: @escaping (Result<Bool, APIError>) -> Void) {
        
        // get the token for the currently logged in user
        let token: String? = getToken()
        
        // construct the URL
        guard let url = URL(string: "http://localhost:3000/resend_confirmation_email") else {
            // if it's not valid, throw a invalid URL error
            completion(.failure(APIError.invalidURL) as Result<Bool, APIError>)
            return
        }
        
        // create the request and set it's properties
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        // pass in the token in the headers for this request
        request.addValue("Bearer \(token ?? "no value")", forHTTPHeaderField: "Authorization")
        
        
        // create the data task
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // check if any data was received from the server
            guard let data = data, error == nil else {
                // return custom errro that there was no data received
                completion(.failure(APIError.serverDown) as Result<Bool, APIError>)
                return
            }
            
            // check the status code of the response
            if let httpResonse = response as? HTTPURLResponse {
                switch httpResonse.statusCode {
                    // if the status code is 200
                case 200:
                    // if everything went well, return the status
                    completion(.success(true))
                case 401:
                    // if the status code is 401, raise invalid credentials error
                    completion(.failure(APIError.invalidCredentials) as Result<Bool, APIError>)
                case 404:
                    completion(.failure(APIError.custom(errorMessage: "User exists or has already been confirmed")) as Result<Bool, APIError>)
                default:
                    // if the status code is not 200 or 401, raise custom error with the status code
                    completion(.failure(APIError.custom(errorMessage: "Status code: \(httpResonse.statusCode)")) as Result<Bool, APIError>)
                }
            }
            
        }.resume()
        
    }
}

