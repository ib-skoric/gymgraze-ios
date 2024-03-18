//
//  OpenFoodFactsService.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 18/03/2024.
//

import Foundation

class OpenFoodFactsService {
    
    func fetch<T: Decodable>(barcode: String, completion: @escaping (Result<T, APIError>) -> Void) {
        guard let url = URL(string: "https://world.openfoodfacts.org/api/v0/product/\(barcode).json") else {
            print("Invalid URL")
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error)")
                completion(.failure(.serverDown))
                return
            }
            
            guard let data = data else {
                print("No data returned from API")
                completion(.failure(.invalidDataReturnedFromAPI))
                return
            }
            
            do {
                let item = try JSONDecoder().decode(T.self, from: data)
                completion(.success(item))
            } catch {
                print("Error decoding item: \(error)")
                completion(.failure(.invalidPayload))
            }
        }.resume()
    }
    
    func fetchFoodItemImage(barcode: String, completion: @escaping (Result<String, APIError>) -> Void) {
        fetch(barcode: barcode, completion: completion)
    }
    
    func fetchFoodItem(barcode: String, completion: @escaping (Result<FoodItem, APIError>) -> Void) {
        fetch(barcode: barcode, completion: completion)
    }
}

