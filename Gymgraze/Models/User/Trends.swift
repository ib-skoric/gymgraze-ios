//
//  Trends.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 13/04/2024.
//

import Foundation

struct Trends: Codable, Identifiable {
    var id = UUID()
    var weights: [Weight]
    var bodyFatPercentages: [BodyFatPercentage]
    var armMeasurements: [ArmMeasurement]
    var waistMeasurements: [WaistMeasurement]
    var chestMeasurements: [ChestMeasurement]
    
    enum CodingKeys: String, CodingKey {
        case weights
        case bodyFatPercentages = "body_fat_percentages"
        case armMeasurements = "arm_measurements"
        case waistMeasurements = "waist_measurements"
        case chestMeasurements = "chest_measurements"
    }
}

struct Weight: Codable {
    var id: Int
    var date: String
    var weight: Double
}

struct BodyFatPercentage: Codable {
    var id: Int
    var date: String
    var bodyFatPercentage: Double?
    
    enum CodingKeys: String, CodingKey {
        case id
        case date
        case bodyFatPercentage = "body_fat_percentage"
    }
}

struct ArmMeasurement: Codable {
    var id: Int
    var date: String
    var armMeasurement: Double?
    
    enum CodingKeys: String, CodingKey {
        case id
        case date
        case armMeasurement = "arm_measurement"
    }
}

struct WaistMeasurement: Codable {
    var id: Int
    var date: String
    var waistMeasurement: Double?
    
    enum CodingKeys: String, CodingKey {
        case id
        case date
        case waistMeasurement = "waist_measurement"
    }
}

struct ChestMeasurement: Codable {
    var id: Int
    var date: String
    var chestMeasurement: Double?
    
    enum CodingKeys: String, CodingKey {
        case id
        case date
        case chestMeasurement = "chest_measurement"
    }
}
