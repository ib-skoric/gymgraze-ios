//
//  FoodDiaryService.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 12/03/2024.
//

import Foundation

class FoodDiaryService {
    
    func fetchFoodDiaryEntry(completion: @escaping (Result<FoodDiaryEntry, APIError>) -> Void) {
        // fetch user from the back end
        // get the token for the currently logged in user
        var token: String? = getToken()
        
        // construct the URL
        guard let url = URL(string: "http://localhost:3000/food_diary_entries/1") else {
            // if it's not valid, throw a invalid URL error
            completion(.failure(APIError.invalidURL) as Result<FoodDiaryEntry, APIError>)
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
                completion(.failure(APIError.serverDown) as Result<FoodDiaryEntry, APIError>)
                return
            }
            
            // check the status code of the response
            if let httpResonse = response as? HTTPURLResponse {
                switch httpResonse.statusCode {
                    // if the status code is 200
                case 200:
                    // try decode the response
                    
                    do {
                        let diaryResponse = try JSONDecoder().decode(FoodDiaryEntry.self, from: data)
                    } catch let error {
                        print("Error decoding FoodDiaryEntry: \(error)")
                    }
                    
                    guard let diaryResponse = try? JSONDecoder().decode(FoodDiaryEntry.self, from: data) else {
                        // raise invalid credentials error
                        completion(.failure(APIError.invalidDataReturnedFromAPI) as Result<FoodDiaryEntry, APIError>)
                        return
                    }
                    
                    // if everything went well, return the entry
                    completion(.success(diaryResponse))
                case 401:
                    // if the status code is 401, raise invalid credentials error
                    completion(.failure(APIError.invalidCredentials) as Result<FoodDiaryEntry, APIError>)
                    
                default:
                    // if the status code is not 200 or 401, raise custom error with the status code
                    completion(.failure(APIError.custom(errorMessage: "Status code: \(httpResonse.statusCode)")) as Result<FoodDiaryEntry, APIError>)
                }
            }
            
        }.resume()
    }
}
