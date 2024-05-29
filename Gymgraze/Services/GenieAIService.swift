//
//  OpenAIService.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 20/04/2024.
//

import Foundation

class OpenAIService {
    
    func getOpenAIResponse(method: String, kcal: Double, protein: Double, carbs: Double, fat: Double, completion: @escaping (Result<String, APIError>) -> Void) {
        let token: String? = getToken()
        
        guard let url = URL(string: "http://localhost:3000/openai") else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.addValue("Bearer \(token ?? "not set")", forHTTPHeaderField: "Authorization")
        
        struct Response: Codable {
            let api_key: String
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
                        let apiKey = response.api_key
                        
                        self.getRecipe(method: method, token: apiKey, kcal: kcal, protein: protein, carbs: carbs, fat: fat) { result in
                            switch result {
                            case .success(let recipe):
                                completion(.success(recipe))
                                print(recipe)
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                        
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
    
    func getRecipe(method: String, token: String, kcal: Double, protein: Double, carbs: Double, fat: Double,  completion: @escaping (Result<String, APIError>) -> Void) {
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            completion(.failure(.invalidURL))
            return
        }
        
        // payload to be sent to OpenAI
        let initialPayload = """
        {
            "model": "gpt-3.5-turbo",
            "messages": [
                {
                    "role": "system",
                    "content": "Your name is GenieAI. You take inputs in form of calories (in kcal) and macros. Your job is to come up with a recipe to fit these requirements. Total kcal that you have at your disposal is \(kcal) and the following macros: Protein: \(protein) grams, Carbs: \(carbs) grams, Fat: \(fat) grams. Two of these three values will always be 0, you are to ignore the zeros and come up with the recipe based on the value that is not 0. That beein said, the meal itself SHOULD CONTAIN THESE macronutrients, they should NOT be 0. For every ingredient, you must provide the approximate number of calories and macros in grams (carbs, fat, protein). For every response, provide a title for the recipe followed by 2 line breaks (do not mention word title explicitly in your response). Then, always reply with a heading ingredients followed by a list of ingredients. Each ingredient should be listed in a new line and should include calories, carbs, fat and protein values. After the ingredients, add two line breaks and then add the Instructions heading and instructions for preparing the recipe. Make sure that the instructions are detailed and have enough detail to be able to prepare the meal even if you are not well versed in the kitchen. Make sure NOT to use any text formatting like markdown or HTML. Reply with plain text and line breaks as instructed. Only ever provide 1 recipe at the time and do not include any other information other than the recipe title, ingredients and instructions."
                }
            ],
            "temperature": 1,
              "max_tokens": 256,
              "top_p": 1,
              "frequency_penalty": 0,
              "presence_penalty": 0
        }
        """
        
        let retryPayload =
        """
        {
                    "model": "gpt-3.5-turbo",
                    "messages": [
                        {
                            "role": "user",
                            "content": "I don't like that recipe, give me another one. Never ask me a question, just provide me with the recipes that satify the same constraints as per my initial message. Do not include any conversational messages such as here is another recipe or i hope that helps. Only ever provide the name of the recipe, the ingredients and the instructions. Do not include any other information."
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
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        // try to encode the body as JSON
        do {
            if method == "initial" {
                request.httpBody = initialPayload.data(using: .utf8)
            } else {
                request.httpBody = retryPayload.data(using: .utf8)
            }
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
                                    if let attributedString = try? String(response.choices[0].message.content) {
                                        completion(.success(attributedString))
                                    } else {
                                        completion(.failure(.invalidDataReturnedFromAPI))
                                    }
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
