//
//  FoodDiaryService.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 12/03/2024.
//

import Foundation

class DiaryService {
    
    func fetch<T: Decodable>(urlString: String, completion: @escaping (Result<T, APIError>) -> Void) {
        let token: String? = getToken()
        
        guard let url = URL(string: urlString) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.addValue("Bearer \(token ?? "not set")", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(.failure(APIError.serverDown))
                return
            }
            
            if let httpResonse = response as? HTTPURLResponse {
                switch httpResonse.statusCode {
                case 200:
                    guard let diaryResponse = try? JSONDecoder().decode(T.self, from: data) else {
                        completion(.failure(APIError.invalidDataReturnedFromAPI))
                        return
                    }
                    completion(.success(diaryResponse))
                case 401:
                    completion(.failure(APIError.invalidCredentials))
                case 404:
                    completion(.failure(APIError.entryNotFound))
                default:
                    completion(.failure(APIError.custom(errorMessage: "Status code: \(httpResonse.statusCode)")))
                }
            }
        }.resume()
    }
    
    func fetchFoodDiaryEntry(date: String, completion: @escaping (Result<FoodDiaryEntry, APIError>) -> Void) {
        fetch(urlString: "http://6914-2a02-8084-181-9600-a8ae-371-ccd3-5f3c.ngrok-free.app/food_diary_entries/\(date)", completion: completion)
    }
    
    func fetchWorkoutDiaryEntry(date: String, completion: @escaping (Result<WorkoutDiaryEntry, APIError>) -> Void) {
        fetch(urlString: "http://6914-2a02-8084-181-9600-a8ae-371-ccd3-5f3c.ngrok-free.app/workout_diary_entries/\(date)", completion: completion)
    }
    
    func fetchFoodItem(foodId: Int, completion: @escaping (Result<Food, APIError>) -> Void) {
        fetch(urlString: "http://6914-2a02-8084-181-9600-a8ae-371-ccd3-5f3c.ngrok-free.app/foods/\(foodId)", completion: completion)
    }
    
    func updateFoodAmount(foodId: Int, amount: Int, completion: @escaping (Result<Food, APIError>) -> Void) {
        let token: String? = getToken()
        
        guard let url = URL(string: "http://6914-2a02-8084-181-9600-a8ae-371-ccd3-5f3c.ngrok-free.app/foods/\(foodId)") else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        let body = ["amount": amount]
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.addValue("Bearer \(token ?? "not set")", forHTTPHeaderField: "Authorization")
        // try to encode the body as JSON
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            print("Error encoding JSON: \(error)")
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(.failure(APIError.serverDown))
                return
            }
            
            if let httpResonse = response as? HTTPURLResponse {
                switch httpResonse.statusCode {
                case 200:
                    guard let diaryResponse = try? JSONDecoder().decode(Food.self, from: data) else {
                        completion(.failure(APIError.invalidDataReturnedFromAPI))
                        return
                    }
                    completion(.success(diaryResponse))
                case 401:
                    completion(.failure(APIError.invalidCredentials))
                case 404:
                    completion(.failure(APIError.entryNotFound))
                default:
                    completion(.failure(APIError.custom(errorMessage: "Status code: \(httpResonse.statusCode)")))
                }
            }
        }.resume()
    }
    
    func removeFoodItem(foodId: Int, completion: @escaping (Result<Bool, APIError>) -> Void) {
        let token: String? = getToken()
        
        guard let url = URL(string: "http://6914-2a02-8084-181-9600-a8ae-371-ccd3-5f3c.ngrok-free.app/foods/\(foodId)") else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.addValue("Bearer \(token ?? "not set")", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(.failure(APIError.serverDown))
                return
            }
            
            if let httpResonse = response as? HTTPURLResponse {
                switch httpResonse.statusCode {
                case 200:
                    completion(.success(true))
                case 401:
                    completion(.failure(APIError.invalidCredentials))
                case 404:
                    completion(.failure(APIError.entryNotFound))
                default:
                    completion(.failure(APIError.custom(errorMessage: "Status code: \(httpResonse.statusCode)")))
                }
            }
        }.resume()
    }
    
    func createFoodDiaryEntry(date: String, completion: @escaping (Result<FoodDiaryEntry, APIError>) -> Void) {
        let token: String? = getToken()
        
        guard let url = URL(string: "http://6914-2a02-8084-181-9600-a8ae-371-ccd3-5f3c.ngrok-free.app/food_diary_entries") else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        let body = ["date": date]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.addValue("Bearer \(token ?? "not set")", forHTTPHeaderField: "Authorization")
        // try to encode the body as JSON
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            print("Error encoding JSON: \(error)")
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(.failure(APIError.serverDown))
                return
            }
            
            if let httpResonse = response as? HTTPURLResponse {
                switch httpResonse.statusCode {
                case 201:
                    guard let diaryResponse = try? JSONDecoder().decode(FoodDiaryEntry.self, from: data) else {
                        completion(.failure(APIError.invalidDataReturnedFromAPI))
                        return
                    }
                    completion(.success(diaryResponse))
                case 401:
                    completion(.failure(APIError.invalidCredentials))
                case 404:
                    completion(.failure(APIError.entryNotFound))
                default:
                    completion(.failure(APIError.custom(errorMessage: "Status code: \(httpResonse.statusCode)")))
                }
            }
        }.resume()
    }
    
    func findOrCreateFoodEntryId(date: String, completion: @escaping (Result<Int, APIError>) -> Void) {
        let token: String? = getToken()
        
        guard let url = URL(string: "http://6914-2a02-8084-181-9600-a8ae-371-ccd3-5f3c.ngrok-free.app/food_diary_entries/\(date)") else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.addValue("Bearer \(token ?? "not set")", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(.failure(APIError.serverDown))
                return
            }
            
            if let httpResonse = response as? HTTPURLResponse {
                switch httpResonse.statusCode {
                case 200:
                    guard let diaryResponse = try? JSONDecoder().decode(FoodDiaryEntry.self, from: data) else {
                        completion(.failure(APIError.invalidDataReturnedFromAPI))
                        return
                    }
                    completion(.success(diaryResponse.id))
                case 401:
                    completion(.failure(APIError.invalidCredentials))
                case 404:
                    self.createFoodDiaryEntry(date: date) { (result) in
                        switch result {
                        case .success(let diaryEntry):
                            completion(.success(diaryEntry.id))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                    completion(.failure(APIError.entryNotFound))
                default:
                    completion(.failure(APIError.custom(errorMessage: "Status code: \(httpResonse.statusCode)")))
                }
            }
        }.resume()
    }
    
    func addFoodToDiary(foodId: Food, amount: Int, date: String, mealId: Int, completion: @escaping (Result<Food, APIError>) -> Void) {
        let token: String? = getToken()
        
        guard let url = URL(string: "http://6914-2a02-8084-181-9600-a8ae-371-ccd3-5f3c.ngrok-free.app/food_diary_entries/\(date)/foods") else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        let body = []
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.addValue("Bearer \(token ?? "not set")", forHTTPHeaderField: "Authorization")
        // try to encode the body as JSON
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            print("Error encoding JSON: \(error)")
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(.failure(APIError.serverDown))
                return
            }
            
            if let httpResonse = response as? HTTPURLResponse {
                switch httpResonse.statusCode {
                case 201:
                    guard let diaryResponse = try? JSONDecoder().decode(Food.self, from: data) else {
                        completion(.failure(APIError.invalidDataReturnedFromAPI))
                        return
                    }
                    completion(.success(diaryResponse))
                case 401:
                    completion(.failure(APIError.invalidCredentials))
                case 404:
                    completion(.failure(APIError.entryNotFound))
                default:
                    completion(.failure(APIError.custom(errorMessage: "Status code: \(httpResonse.statusCode)")))
                }
            }
        }.resume()
    }
}

