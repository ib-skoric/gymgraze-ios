//
//  OpenFoodFactsService.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 18/03/2024.
//

import Foundation

class OpenFoodFactsService {
    
    func fetchFoodItemImage(barcode: String, completion: @escaping (Result<String, APIError>) -> Void) {
        let url = URL(string: "https://world.openfoodfacts.org/api/v0/product/\(barcode).json")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching food item image: \(error)")
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
                completion(.success(foodItem.product.imageURL ?? "https://placehold.co/400"))
            } catch {
                print("Error decoding food item: \(error)")
                completion(.failure(.invalidPayload))
            }
        }.resume()
    }
    
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
    
    func searchForFood(searchTerm: String, completion: @escaping (Result<[FoodItem.Product], APIError>) -> Void) {
        let url = URL(string: "https://world.openfoodfacts.org/cgi/search.pl?search_terms=\(searchTerm)&search_simple=1&action=process&json=1")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error searching for food: \(error)")
                completion(.failure(.serverDown))
                return
            }
            
            guard let data = data else {
                print("No data returned from API")
                completion(.failure(.invalidDataReturnedFromAPI))
                return
            }
            
            do {
                let searchResult = try JSONDecoder().decode(OpenFoodFactsSearchResult.self, from: data)
                completion(.success(searchResult.products))
            } catch {
                print("Error decoding search result: \(error)")
                completion(.failure(.invalidPayload))
            }
        }.resume()
    }
}
