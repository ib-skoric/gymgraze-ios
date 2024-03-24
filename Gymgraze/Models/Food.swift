//
//  Food.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 25/01/2024.
//

import Foundation

/// Food object model
struct Food: Codable, Identifiable {
    var id: Int
    var barcode: String
    var name: String
    var amount: Int
    var nutritionalInfo: NutritionalInfo
    var totalNutrition: NutritionalInfo
    var meal: Meal
    
    enum CodingKeys: String, CodingKey {
        case id
        case barcode
        case name
        case amount
        case nutritionalInfo = "nutritional_info"
        case totalNutrition = "total_nutrition"
        case meal
    }
    
    init() {
        id = 0
        barcode = ""
        name = ""
        amount = 0
        nutritionalInfo = NutritionalInfo()
        totalNutrition = NutritionalInfo()
        meal = Meal()
    }
}

struct FoodItem: Codable, Identifiable {
    var id: String
    var product: Product
    
    struct Product: Codable, Identifiable {
        var id: String
        var productName: String?
        var imageURL: String?
        var nutriments: Nutriments
        
        enum CodingKeys: String, CodingKey {
            case id = "_id"
            case productName = "product_name"
            case imageURL = "image_thumb_url"
            case nutriments
        }
        
        init() {
            id = ""
            productName = ""
            imageURL = ""
            nutriments = Nutriments()
        }
    }
    
    struct Nutriments: Codable {
        var kcal100g: Int?
        var carbs100g: Double?
        var protein100g: Double?
        var fat100g: Double?
        var salt100g: Double?
        var sugar100g: Double?
        var fiber100g: Double?
        
        enum CodingKeys: String, CodingKey {
            case kcal100g = "energy-kcal_100g"
            case carbs100g = "carbohydrates_100g"
            case protein100g = "proteins_100g"
            case fat100g = "fat_100g"
            case salt100g = "salt_100g"
            case sugar100g = "sugars_100g"
            case fiber100g = "fiber_100g"
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            kcal100g = try? container.decode(Int.self, forKey: .kcal100g)
            carbs100g = try? container.decode(Double.self, forKey: .carbs100g)
            protein100g = try? container.decode(Double.self, forKey: .protein100g)
            fat100g = try? container.decode(Double.self, forKey: .fat100g)
            salt100g = try? container.decode(Double.self, forKey: .salt100g)
            sugar100g = try? container.decode(Double.self, forKey: .sugar100g)
            fiber100g = try? container.decode(Double.self, forKey: .fiber100g)
            
            if carbs100g == nil {
                if let carbsString = try? container.decode(String.self, forKey: .carbs100g) {
                    carbs100g = Double(carbsString)
                }
            }
            
            if protein100g == nil {
                if let proteinString = try? container.decode(String.self, forKey: .carbs100g) {
                    protein100g = Double(proteinString)
                }
            }
            
            if fat100g == nil {
                if let fatString = try? container.decode(String.self, forKey: .carbs100g) {
                    fat100g = Double(fatString)
                }
            }
            
            if salt100g == nil {
                if let saltString = try? container.decode(String.self, forKey: .carbs100g) {
                    salt100g = Double(saltString)
                }
            }
            
            if sugar100g == nil {
                if let sugarString = try? container.decode(String.self, forKey: .carbs100g) {
                    sugar100g = Double(sugarString)
                }
            }
            
            if fiber100g == nil {
                if let fiberString = try? container.decode(String.self, forKey: .carbs100g) {
                    fiber100g = Double(fiberString)
                }
            }
        }
        
        init() {
            self.kcal100g = 0
            self.carbs100g = 0
            self.protein100g = 0
            self.fat100g = 0
            self.salt100g = 0
            self.sugar100g = 0
            self.fiber100g = 0
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "code"
        case product
    }
    
    init(id: String, product: Product) {
        self.id = id
        self.product = product
    }
    
    init() {
        id = ""
        product = Product()
    }
}
