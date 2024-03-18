//
//  OpenFoodFactsService.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 18/03/2024.
//

import Foundation

class OpenFoodFactsService {
    func fetchFoodItem(barcode: String, completion: @escaping (Result<FoodItem, APIError>) -> Void) {
        let url = URL(string: "https://world.openfoodfacts.org/api/v0/product/\(barcode).json")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching food item: \(error)")
                completion(.failure(.serverDown))
                return
            }
            
            guard let data = data else {
                print("No data returned from API")
                completion(.failure(.invalidDataReturnedFromAPI))
                return
            }
            
            do {
                let foodItem = try JSONDecoder().decode(FoodItem.self, from: data)
                completion(.success(foodItem))
                print(foodItem)
            } catch {
                print("Error decoding food item: \(error)")
                completion(.failure(.invalidPayload))
            }
        }.resume()
    }
}
