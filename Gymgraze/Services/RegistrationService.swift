//
//  WebService.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 30/01/2024.
//

import Foundation

class RegistrationService {
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
