//
//  FoodDiaryService.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 12/03/2024.
//

import Foundation

class DiaryService {
    
    func request<T: Codable>(urlString: String, method: String, body: [String: Any]? = nil, completion: @escaping (Result<T, APIError>) -> Void) {
        let token: String? = getToken()
        
        guard let url = URL(string: urlString) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.addValue("Bearer \(token ?? "not set")", forHTTPHeaderField: "Authorization")
        
        if let body = body {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                print("Error encoding JSON: \(error)")
            }
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(.failure(APIError.serverDown))
                return
            }
            
            if let httpResonse = response as? HTTPURLResponse {
                switch httpResonse.statusCode {
                case 200...299:
                    do {
                        let diaryResponse = try JSONDecoder().decode(T.self, from: data)
                        // Continue with your logic using diaryResponse
                        completion(.success(diaryResponse))
                    } catch let error {
                        print("Decoding failed with error: \(error)")
                        completion(.failure(APIError.invalidDataReturnedFromAPI))
                    }
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
        request(urlString: "http://localhost:3000/foods/\(foodId)", method: "GET", completion: completion)
    }
    
    func updateFoodAmount(foodId: Int, amount: Int, completion: @escaping (Result<Food, APIError>) -> Void) {
        request(urlString: "http://localhost:3000/foods/\(foodId)", method: "PUT", body: ["amount": amount], completion: completion)
    }
    
    func removeFoodItem(foodId: Int, completion: @escaping (Result<Bool, APIError>) -> Void) {
        request(urlString: "http://localhost:3000/foods/\(foodId)", method: "DELETE", completion: completion)
    }
    
    func createFoodDiaryEntry(date: String, completion: @escaping (Result<FoodDiaryEntry, APIError>) -> Void) {
        request(urlString: "http://localhost:3000/food_diary_entries", method: "POST", body: ["date": date], completion: completion)
    }
    
    func createWorkoutDiaryEntry(date: String, completion: @escaping (Result<WorkoutDiaryEntry, APIError>) -> Void) {
        request(urlString: "http://localhost:3000/workout_diary_entries", method: "POST", body: ["date": date], completion: completion)
    }
    
    func fetchFoodDiaryEntry(date: String, completion: @escaping (Result<FoodDiaryEntry, APIError>) -> Void) {
        request(urlString: "http://localhost:3000/food_diary_entries/\(date)", method: "GET", completion: completion)
    }
    
    func fetchWorkoutDiaryEntry(date: String, completion: @escaping (Result<WorkoutDiaryEntry, APIError>) -> Void) {
        request(urlString: "http://localhost:3000/workout_diary_entries/\(date)", method: "GET", completion: completion)
    }
    
    func addFoodToDiary(food: FoodItem, amount: Int, date: String, mealId: Int, nutritionalInfo: FoodItem.Nutriments, completion: @escaping (Result<Food, APIError>) -> Void) {
        let body: [String: Any] = [
            "name": food.product.productName ?? "No name found",
            "barcode": food.id,
            "amount": amount,
            "meal_id": mealId,
            "nutritional_info_attributes": [
                "kcal": nutritionalInfo.kcal100g ?? 0,
                "carbs": nutritionalInfo.carbs100g ?? 0.0,
                "fat": nutritionalInfo.fat100g ?? 0.0,
                "protein": nutritionalInfo.protein100g ?? 0.0,
                "salt": nutritionalInfo.salt100g ?? 0.0,
                "sugar": nutritionalInfo.sugar100g ?? 0.0,
                "fiber": nutritionalInfo.fiber100g ?? 0.0
            ]
        ]
        
        fetchFoodDiaryEntry(date: date) { result in
            switch result {
            case .success(let foodDiaryEntry):
                var bodyWithDiaryId = body
                bodyWithDiaryId["food_diary_entry_id"] = foodDiaryEntry.id
                self.request(urlString: "http://localhost:3000/foods", method: "POST", body: bodyWithDiaryId, completion: completion)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func saveWorkout(date: Date, exercises: [Exercise], completion: @escaping (Result<Workout, APIError>) -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        
        fetchWorkoutDiaryEntry(date: dateString) { result in
            switch result {
            case .success(let workoutDiaryEntry):
                let workoutBody: [String: Any] = [
                    "workout_diary_entry_id": String(workoutDiaryEntry.id),
                    "date": dateString
                ]
                self.request(urlString: "http://localhost:3000/workouts", method: "POST", body: workoutBody) { (result: Result<Workout, APIError>) in
                    switch result {
                    case .success(let workout):
                        self.createExercises(workoutId: workout.id, exercises: exercises) { result in
                            switch result {
                            case .success(_):
                                completion(.success(workout))
                            case .failure(let error):
                                print(error)
                            }
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    
    func createExercises(workoutId: Int, exercises: [Exercise], completion: @escaping (Result<Bool, APIError>) -> Void) {
        let token: String? = getToken()
        
        guard let exerciseURL = URL(string: "http://localhost:3000/exercises") else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        var exerciseRequest = URLRequest(url: exerciseURL)
        
        exerciseRequest.httpMethod = "POST"
        exerciseRequest.addValue("application/json", forHTTPHeaderField: "Content-type")
        exerciseRequest.addValue("Bearer \(token ?? "not set")", forHTTPHeaderField: "Authorization")
        
        var exercisesToAPI: [ExerciseToAPI] = []
        
        // loop over all the passed in exercises and create a new exerciseToAPI
        for exercise in exercises {
            exercisesToAPI.append(ExerciseToAPI(exercise: exercise, workoutId: workoutId))
        }
        
        let exercisesDict = ["exercises": exercisesToAPI]
        do {
            exerciseRequest.httpBody = try JSONEncoder().encode(exercisesDict)
            // print the JSON sent to server
            print(String(data: exerciseRequest.httpBody!, encoding: .utf8)!)
        } catch {
            print("Error encoding JSON: \(error)")
        }

        
        URLSession.shared.dataTask(with: exerciseRequest) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(.failure(APIError.serverDown))
                return
            }
            
            if let httpResonse = response as? HTTPURLResponse {
                switch httpResonse.statusCode {
                case 201:
                    completion(.success(true))
                case 401:
                    completion(.failure(APIError.invalidCredentials))
                default:
                    completion(.failure(APIError.custom(errorMessage: "Status code: \(httpResonse.statusCode)")))
                }
            }
        }.resume()
        
    }
}

