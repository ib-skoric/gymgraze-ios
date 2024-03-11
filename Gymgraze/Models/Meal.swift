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
    var createdAt: Date
    var updatedAt: Date
    
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
        
        // Decode the ISO8601 date string into a Swift Date
        let isoDateCreatedAt = try container.decode(String.self, forKey: .createdAt)
        let isoDateUpdatedAt = try container.decode(String.self, forKey: .updatedAt)
        let dateFormatter = ISO8601DateFormatter()
        createdAt = dateFormatter.date(from: isoDateCreatedAt) ?? Date()
        updatedAt = dateFormatter.date(from: isoDateUpdatedAt) ?? Date()
    }
}
