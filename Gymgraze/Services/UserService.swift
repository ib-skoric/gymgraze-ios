//
//  UserService.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 15/02/2024.
//

import Foundation

class UserService {
    
    func fetchUser(completion: @escaping (Result<User, APIError>) -> Void) {
        // fetch user from the back end
        // get the token for the currently logged in user
        var token: String? = getToken()
        
        // construct the URL
        guard let url = URL(string: "http://localhost:3000/profile") else {
            // if it's not valid, throw a invalid URL error
            completion(.failure(APIError.invalidURL) as Result<User, APIError>)
            return
        }
        
        // create the request and set it's properties
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        // pass in the token in the headers for this request
        request.addValue("Bearer \(token ?? "not set")", forHTTPHeaderField: "Authorization")
        
        // create the data task
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // check if any data was received from the server
            guard let data = data, error == nil else {
                // return custom errro that there was no data received
                completion(.failure(APIError.serverDown) as Result<User, APIError>)
                return
            }
            
            // check the status code of the response
            if let httpResonse = response as? HTTPURLResponse {
                switch httpResonse.statusCode {
                    // if the status code is 200
                case 200:
                    // try decode the response
                    guard let userResponse = try? JSONDecoder().decode(User.self, from: data) else {
                        // raise invalid credentials error
                        completion(.failure(APIError.invalidCredentials) as Result<User, APIError>)
                        return
                    }
                    
                    // if everything went well, return the user
                    completion(.success(userResponse))
                case 401:
                    // if the status code is 401, raise invalid credentials error
                    completion(.failure(APIError.invalidCredentials) as Result<User, APIError>)
                    
                default:
                    // if the status code is not 200 or 401, raise custom error with the status code
                    completion(.failure(APIError.custom(errorMessage: "Status code: \(httpResonse.statusCode)")) as Result<User, APIError>)
                }
            }
            
        }.resume()
        
    }
    
func requestPasswordReset(email: String, completion: @escaping (Result<Bool, APIError>) -> Void) {
        
        // construct the URL
        guard let url = URL(string: "http://localhost:3000/request_password_reset") else {
            // if it's not valid, throw a invalid URL error
            completion(.failure(APIError.invalidURL) as Result<Bool, APIError>)
            return
        }
        
        // construct the body as JSON
        let body = ["email": email]
        
        // create the request and set it's properties
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
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
                completion(.failure(APIError.serverDown) as Result<Bool, APIError>)
                return
            }
            
            // check the status code of the response
            if let httpResonse = response as? HTTPURLResponse {
                switch httpResonse.statusCode {
                    // if the status code is 200
                case 202:
                    completion(.success(true) as Result<Bool, APIError>)
                    return
                case 404:
                    completion(.failure(APIError.userNotFound) as Result<Bool, APIError>)
                default:
                    // if the status code is not 200 or 401, raise custom error with the status code
                    completion(.failure(APIError.custom(errorMessage: "Status code: \(httpResonse.statusCode)")) as Result<Bool, APIError>)
                }
            }
            
        }.resume()
    }
    
    func validatePasswordResetCode(token: String, completion: @escaping (Result<Bool, APIError>) -> Void) {
        // construct the URL
        guard let url = URL(string: "http://localhost:3000/validate_password_reset_token") else {
            // if it's not valid, throw a invalid URL error
            completion(.failure(APIError.invalidURL) as Result<Bool, APIError>)
            return
        }
        
        // construct the body as JSON
        let body = ["token": token]
        
        // create the request and set it's properties
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        // try to encode the body as JSON
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            print("Error encoding JSON: \(error)")
        }
        
        // create the data task
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // check if any data was received from the server
            guard let _ = data, error == nil else {
                // return custom errro that there was no data received
                completion(.failure(APIError.serverDown) as Result<Bool, APIError>)
                return
            }
            
            // check the status code of the response
            if let httpResonse = response as? HTTPURLResponse {
                switch httpResonse.statusCode {
                    // if the status code is 200
                case 202:
                    completion(.success(true) as Result<Bool, APIError>)
                    return
                case 401:
                    completion(.failure(APIError.invalidCredentials) as Result<Bool, APIError>)
                default:
                    // if the status code is not 200 or 401, raise custom error with the status code
                    completion(.failure(APIError.custom(errorMessage: "Status code: \(httpResonse.statusCode)")) as Result<Bool, APIError>)
                }
            }
            
        }.resume()
    }
  
  func setGoal(goal: GoalPayload, completion: @escaping (Result<Goal, APIError>) -> Void) {
        // fetch user from the back end
        // get the token for the currently logged in user
      let token: String? = getToken()
        
        // construct the URL
        guard let url = URL(string: "http://localhost:3000/goals") else {
            // if it's not valid, throw a invalid URL error
            completion(.failure(APIError.invalidURL) as Result<Goal, APIError>)
            return
        }
        
        let body = goal
        
        // create the request and set it's properties
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        // pass in the token in the headers for this request
        request.addValue("Bearer \(token ?? "not set")", forHTTPHeaderField: "Authorization")
        request.httpBody = try? JSONEncoder().encode(body)
        
        // create the data task
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // check if any data was received from the server
            guard let data = data, error == nil else {
                // return custom errro that there was no data received
                completion(.failure(APIError.serverDown) as Result<Goal, APIError>)
                return
            }
            
            // check the status code of the response
            if let httpResonse = response as? HTTPURLResponse {
                switch httpResonse.statusCode {
                    // if the status code is 200
                case 201:
                    // try decode the response
                    guard let goalResponse = try? JSONDecoder().decode(Goal.self, from: data) else {
                        // raise invalid credentials error
                        completion(.failure(APIError.invalidPayload) as Result<Goal, APIError>)
                        return
                    }
                    
                    // if everything went well, return the user
                    completion(.success(goalResponse))
                case 422:
                    // if the status code is 401, raise invalid credentials error
                    completion(.failure(APIError.custom(errorMessage: "Something went wrong validating your goals")) as Result<Goal, APIError>)
                    
                default:
                    // if the status code is not 200 or 401, raise custom error with the status code
                    completion(.failure(APIError.custom(errorMessage: "Status code: \(httpResonse.statusCode)")) as Result<Goal, APIError>)
                }
            }
            
        }.resume()
  }
}
