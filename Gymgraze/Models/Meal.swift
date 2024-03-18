//
//  Meal.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 25/01/2024.
//

import Foundation

/// Meal object model
struct Meal: Codable, Hashable {
    var id: Int
    var name: String
    var createdAt: Date?
    var updatedAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        
        if let createdAtTimestamp = try container.decodeIfPresent(Double.self, forKey: .createdAt) {
            createdAt = Date(timeIntervalSince1970: createdAtTimestamp)
        }
        
        if let updatedAtTimestamp = try container.decodeIfPresent(Double.self, forKey: .updatedAt) {
            updatedAt = Date(timeIntervalSince1970: updatedAtTimestamp)
        }
    }
    
    init() {
        id = 0
        name = ""
        createdAt = nil
        updatedAt = nil
    }
}
