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
    
    func fetchFoodItem(foodId: Int, completion: @escaping (Result<Food, APIError>) -> Void) {
        fetch(urlString: "http://localhost:3000/foods/\(foodId)", completion: completion)
    }
    
    func updateFoodAmount(foodId: Int, amount: Int, completion: @escaping (Result<Food, APIError>) -> Void) {
        let token: String? = getToken()
        
        guard let url = URL(string: "http://localhost:3000/foods/\(foodId)") else {
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
        
        guard let url = URL(string: "http://localhost:3000/foods/\(foodId)") else {
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
        
        guard let url = URL(string: "http://localhost:3000/food_diary_entries") else {
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
    
    func createWorkoutDiaryEntry(date: String, completion: @escaping (Result<WorkoutDiaryEntry, APIError>) -> Void) {
        let token: String? = getToken()
        
        guard let url = URL(string: "http://localhost:3000/workout_diary_entries") else {
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
                    guard let diaryResponse = try? JSONDecoder().decode(WorkoutDiaryEntry.self, from: data) else {
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
        fetch(urlString: "http://localhost:3000/food_diary_entries/\(date)") { (result: Result<FoodDiaryEntry, APIError>) in
            switch result {
            case .success(let foodDiaryEntry):
                completion(.success(foodDiaryEntry))
            case .failure(let error):
                if error == APIError.entryNotFound {
                    // create new entry with this date
                    DiaryService().createFoodDiaryEntry(date: date) { result in
                        switch result {
                        case .success(let foodDiaryEntry):
                            completion(.success(foodDiaryEntry))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                } else {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func fetchWorkoutDiaryEntry(date: String, completion: @escaping (Result<WorkoutDiaryEntry, APIError>) -> Void) {
        fetch(urlString: "http://localhost:3000/workout_diary_entries/\(date)") { (result: Result<WorkoutDiaryEntry, APIError>) in
            switch result {
            case .success(let foodDiaryEntry):
                completion(.success(foodDiaryEntry))
            case .failure(let error):
                if error == APIError.entryNotFound {
                    // create new entry with this date
                    DiaryService().createWorkoutDiaryEntry(date: date) { result in
                        switch result {
                        case .success(let workoutDiaryEntry):
                            completion(.success(workoutDiaryEntry))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                } else {
                    completion(.failure(error))
                }
            }
        }
    }
    
    
    //    func addFoodToDiary(foodId: Food, amount: Int, date: String, mealId: Int, completion: @escaping (Result<Food, APIError>) -> Void) {
    //        let token: String? = getToken()
    //
    //        guard let url = URL(string: "http://localhost:3000/food_diary_entries/\(date)/foods") else {
    //            completion(.failure(APIError.invalidURL))
    //            return
    //        }
    //
    //        let body = []
    //
    //        var request = URLRequest(url: url)
    //        request.httpMethod = "POST"
    //        request.addValue("application/json", forHTTPHeaderField: "Content-type")
    //        request.addValue("Bearer \(token ?? "not set")", forHTTPHeaderField: "Authorization")
    //        // try to encode the body as JSON
    //        do {
    //            request.httpBody = try JSONEncoder().encode(body)
    //        } catch {
    //            print("Error encoding JSON: \(error)")
    //        }
    //
    //        URLSession.shared.dataTask(with: request) { (data, response, error) in
    //            guard let data = data, error == nil else {
    //                completion(.failure(APIError.serverDown))
    //                return
    //            }
    //
    //            if let httpResonse = response as? HTTPURLResponse {
    //                switch httpResonse.statusCode {
    //                case 201:
    //                    guard let diaryResponse = try? JSONDecoder().decode(Food.self, from: data) else {
    //                        completion(.failure(APIError.invalidDataReturnedFromAPI))
    //                        return
    //                    }
    //                    completion(.success(diaryResponse))
    //                case 401:
    //                    completion(.failure(APIError.invalidCredentials))
    //                case 404:
    //                    completion(.failure(APIError.entryNotFound))
    //                default:
    //                    completion(.failure(APIError.custom(errorMessage: "Status code: \(httpResonse.statusCode)")))
    //                }
    //            }
    //        }.resume()
    //    }
}

