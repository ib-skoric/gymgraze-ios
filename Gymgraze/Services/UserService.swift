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
        guard let url = URL(string: "http://rattler-amusing-explicitly.ngrok-free.app/user") else {
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
                        completion(.failure(APIError.invalidDataReturnedFromAPI) as Result<User, APIError>)
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
        guard let url = URL(string: "http://rattler-amusing-explicitly.ngrok-free.app/request_password_reset") else {
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
        guard let url = URL(string: "http://rattler-amusing-explicitly.ngrok-free.app/validate_password_reset_token") else {
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
                    // if the status code is 202
                case 202:
                    completion(.success(true) as Result<Bool, APIError>)
                    return
                case 401:
                    completion(.failure(APIError.invalidCredentials) as Result<Bool, APIError>)
                default:
                    // if the status code is not 202 or 401, raise custom error with the status code
                    completion(.failure(APIError.custom(errorMessage: "Status code: \(httpResonse.statusCode)")) as Result<Bool, APIError>)
                }
            }
            
        }.resume()
    }
    
    func resetPsasword(token: String, password: String, completion: @escaping (Result<Bool, APIError>) -> Void) {
        // construct the URL
        guard let url = URL(string: "http://rattler-amusing-explicitly.ngrok-free.app/reset_password") else {
            // if it's not valid, throw a invalid URL error
            completion(.failure(APIError.invalidURL) as Result<Bool, APIError>)
            return
        }
        
        // construct the body as JSON
        let body = ["token": token, "password": password]
        
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
                // return custom error that there was no data received
                completion(.failure(APIError.serverDown) as Result<Bool, APIError>)
                return
            }
            
            // check the status code of the response
            if let httpResonse = response as? HTTPURLResponse {
                switch httpResonse.statusCode {
                    // if the status code is 202
                case 202:
                    completion(.success(true) as Result<Bool, APIError>)
                    return
                case 401:
                    completion(.failure(APIError.invalidCredentials) as Result<Bool, APIError>)
                default:
                    // if the status code is not 202 or 401, raise custom error with the status code
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
        guard let url = URL(string: "http://rattler-amusing-explicitly.ngrok-free.app/goals") else {
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
                    // if the status code is 201
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
                    // if the status code is 422, raise invalid credentials error
                    completion(.failure(APIError.custom(errorMessage: "Something went wrong validating your goals")) as Result<Goal, APIError>)
                    
                default:
                    // if the status code is not 201 or 401, raise custom error with the status code
                    completion(.failure(APIError.custom(errorMessage: "Status code: \(httpResonse.statusCode)")) as Result<Goal, APIError>)
                }
            }
            
        }.resume()
    }
    
    func fetchExercisesForUser(completion: @escaping (Result<[ExerciseType], APIError>) -> Void) {
        let token: String? = getToken()
        
        guard let url = URL(string: "http://rattler-amusing-explicitly.ngrok-free.app/exercise_types") else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
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
                    do {
                        let exercises = try JSONDecoder().decode([ExerciseType].self, from: data)
                        completion(.success(exercises))
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
    
    func createExerciseType(name: String, category: String, compeltion: @escaping (Result<ExerciseType, APIError>) -> Void) {
        let token: String? = getToken()
        
        guard let url = URL(string: "http://rattler-amusing-explicitly.ngrok-free.app/exercise_types") else {
            compeltion(.failure(APIError.invalidURL))
            return
        }
        
        let body = ["name": name, "exercise_category": category]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.addValue("Bearer \(token ?? "not set")", forHTTPHeaderField: "Authorization")
        request.httpBody = try? JSONEncoder().encode(body)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                compeltion(.failure(APIError.serverDown))
                return
            }
            
            if let httpResonse = response as? HTTPURLResponse {
                switch httpResonse.statusCode {
                case 201:
                    do {
                        let exercise = try JSONDecoder().decode(ExerciseType.self, from: data)
                        compeltion(.success(exercise))
                    } catch let decodeError {
                        print("Decoding failed with error: \(decodeError)")
                        print("Failed to decode data: \(String(data: data, encoding: .utf8) ?? "N/A")")
                        compeltion(.failure(APIError.invalidDataReturnedFromAPI))
                    }
                case 401:
                    compeltion(.failure(APIError.invalidCredentials))
                default:
                    compeltion(.failure(APIError.custom(errorMessage: "Status code: \(httpResonse.statusCode)")))
                }
            }
        }.resume()
    }
    
    func fetchWorkoutTemplates(completion: @escaping (Result<[WorkoutTemplate], APIError>) -> Void) {
        let token: String? = getToken()
        
        guard let url = URL(string: "http://rattler-amusing-explicitly.ngrok-free.app/workout_templates") else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
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
                    do {
                        let workoutTemplates = try JSONDecoder().decode([WorkoutTemplate].self, from: data)
                        completion(.success(workoutTemplates))
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
    
    func saveWorkoutTemplate(workoutTemplate: TemplateToAPI, completion: @escaping (Result<WorkoutTemplate, APIError>) -> Void) {
        let token: String? = getToken()
        
        guard let url = URL(string: "http://rattler-amusing-explicitly.ngrok-free.app/workout_templates") else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.addValue("Bearer \(token ?? "not set")", forHTTPHeaderField: "Authorization")
        request.httpBody = try? JSONEncoder().encode(workoutTemplate)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(.failure(APIError.serverDown))
                return
            }
            
            if let httpResonse = response as? HTTPURLResponse {
                switch httpResonse.statusCode {
                case 201:
                    do {
                        let workoutTemplate = try JSONDecoder().decode(WorkoutTemplate.self, from: data)
                        completion(.success(workoutTemplate))
                    } catch let decodeError {
                        print("Decoding failed with error: \(decodeError)")
                        print("Failed to decode data: \(String(data: data, encoding: .utf8) ?? "N/A")")
                        // Debug block
                        debugPrint("Data that was returned from the API: \(String(data: data, encoding: .utf8) ?? "N/A")")
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
    
    func updatePersonalDetails(personalDetails: PersonalDetails, completion: @escaping (Result<User, APIError>) -> Void) {
        let token: String? = getToken()
        
        print("Personal details: ", personalDetails)
        
        guard let url = URL(string: "http://rattler-amusing-explicitly.ngrok-free.app/update_profile") else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.addValue("Bearer \(token ?? "not set")", forHTTPHeaderField: "Authorization")
        request.httpBody = try? JSONEncoder().encode(personalDetails)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(.failure(APIError.serverDown))
                return
            }
            
            if let httpResonse = response as? HTTPURLResponse {
                switch httpResonse.statusCode {
                case 202:
                    do {
                        let user = try JSONDecoder().decode(User.self, from: data)
                        completion(.success(user))
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
    
    func createMeal(meal: MealToAPI, completion: @escaping (Result<Meal, APIError>) -> Void) {
        let token: String? = getToken()
        
        guard let url = URL(string: "http://rattler-amusing-explicitly.ngrok-free.app/meals") else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.addValue("Bearer \(token ?? "not set")", forHTTPHeaderField: "Authorization")
        request.httpBody = try? JSONEncoder().encode(meal)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(.failure(APIError.serverDown))
                return
            }
            
            if let httpResonse = response as? HTTPURLResponse {
                switch httpResonse.statusCode {
                case 201:
                    do {
                        let meal = try JSONDecoder().decode(Meal.self, from: data)
                        completion(.success(meal))
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
    
    func updateMeals(meals: [MealToAPI], completion: @escaping (Result<[Meal], APIError>) -> Void) {
        let token: String? = getToken()
        
        guard let url = URL(string: "http://rattler-amusing-explicitly.ngrok-free.app/update_all_meals") else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.addValue("Bearer \(token ?? "not set")", forHTTPHeaderField: "Authorization")
        
        let payload = ["meals": meals]
        
        request.httpBody = try? JSONEncoder().encode(payload)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(.failure(APIError.serverDown))
                return
            }
            
            if let httpResonse = response as? HTTPURLResponse {
                switch httpResonse.statusCode {
                case 202:
                    do {
                        let meals = try JSONDecoder().decode([Meal].self, from: data)
                        completion(.success(meals))
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
    
    func deleteMeal(id: Int, completion: @escaping (Result<[Meal], APIError>) -> Void) {
        let token: String? = getToken()
        
        guard let url = URL(string: "http://rattler-amusing-explicitly.ngrok-free.app/meals/\(id)") else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("Bearer \(token ?? "not set")", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(.failure(APIError.serverDown))
                return
            }
            
            if let httpResonse = response as? HTTPURLResponse {
                switch httpResonse.statusCode {
                case 204:
                    do {
                        let meals = try JSONDecoder().decode([Meal].self, from: data)
                        completion(.success(meals))
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
    
    func fetchTrends(completion: @escaping (Result<Trends, APIError>) -> Void) {
        let token: String? = getToken()
        
        guard let url = URL(string: "http://rattler-amusing-explicitly.ngrok-free.app/trends") else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token ?? "not set")", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(.failure(APIError.serverDown))
                return
            }
            
            if let httpResonse = response as? HTTPURLResponse {
                switch httpResonse.statusCode {
                case 200:
                    do {
                        let trends = try JSONDecoder().decode(Trends.self, from: data)
                        completion(.success(trends))
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
}
