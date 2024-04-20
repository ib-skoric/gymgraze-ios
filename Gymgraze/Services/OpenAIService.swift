//
//  OpenAIService.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 20/04/2024.
//

import Foundation

class OpenAIService {
    
    func getOpenAIKey(completion: @escaping (Result<String, APIError>) -> Void) {
        let token: String? = getToken()
        
        guard let url = URL(string: "http://rattler-amusing-explicitly.ngrok-free.app/openai") else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.addValue("Bearer \(token ?? "not set")", forHTTPHeaderField: "Authorization")
        
        struct Response: Codable {
            let api_token: String
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(.failure(APIError.serverDown))
                return
            }
            
            if let httpResonse = response as? HTTPURLResponse {
                switch httpResonse.statusCode {
                case 200:
                    do {
                        let response = try JSONDecoder().decode(Response.self, from: data)
                        completion(.success(response.api_token))
                    } catch let decodeError {
                        print("Decoding failed with error: \(decodeError)")
                        print("Failed to decode data: \(String(data: data, encoding: .utf8) ?? "N/A")")
                        completion(.failure(APIError.invalidDataReturnedFromAPI))
                    }
                case 401:
                    completion(.failure(APIError.invalidCredentials))
                default:
                    completion(.failure(APIError.custom(errorMessage: "Status code: \(httpResonse.statusCode)")))
                }
            }
        }.resume()
    }
    
    func getRecipe(macros: Macros, completion: @escaping (Result<String, APIError>) -> Void) {
        var token: String?
        
        getOpenAIKey { result in
            switch result {
            case .success(let key):
                token = key
            case .failure(let error):
                completion(.failure(.invalidCredentials))
            }
        }
        
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            completion(.failure(.invalidURL))
            return
        }
        
        // payload to be sent to OpenAI
        let payload = """
        {
            "model": "gpt-3.5-turbo",
            "messages": [
                {
                    "role": "system",
                    "content": "You are a dietitian. Your client is a bodybuilder who wants to know the best recipe for a meal with the following macros: \(macros.calories) kcal, \(macros.protein)g protein, \(macros.carbs)g carbs, \(macros.fat)g fat."
                }
            ],
            "temperature": 1,
              "max_tokens": 256,
              "top_p": 1,
              "frequency_penalty": 0,
              "presence_penalty": 0
        }
        """
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.addValue("Bearer \(token ?? "not set")", forHTTPHeaderField: "Authorization")
        // try to encode the body as JSON
        do {
            request.httpBody = try JSONEncoder().encode(payload)
        } catch {
            print("Error encoding JSON: \(error)")
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(.failure(.serverDown))
                return
            }
            
            if let httpResonse = response as? HTTPURLResponse {
                switch httpResonse.statusCode {
                case 200:
                    do {
                        let response = try JSONDecoder().decode(OpenAIResponse.self, from: data)
                        completion(.success(response.choices[0].message.content))
                    } catch let decodeError {
                        print("Decoding failed with error: \(decodeError)")
                        print("Failed to decode data: \(String(data: data, encoding: .utf8) ?? "N/A")")
                        completion(.failure(.invalidDataReturnedFromAPI))
                    }
                case 401:
                    completion(.failure(.invalidCredentials))
                default:
                    completion(.failure(.custom(errorMessage: "Status code: \(httpResonse.statusCode)")))
                }
            }
        }.resume()
    }
}
