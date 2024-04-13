//
//  ProgressDiaryEntry.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 13/04/2024.
//

import Foundation

struct ProgressDiaryEntry: Codable, Identifiable {
    var id: Int
    var date: String
    var weight: Double
    var armMeasurement: Double?
    var waistMeasurement: Double?
    var bodyFatPercentage: Double?
    var chestMeasurement: Double?
    
    init() {
        id = 0
        date = ""
        weight = 0
        armMeasurement = 0
        waistMeasurement = 0
        bodyFatPercentage = 0
        chestMeasurement = 0
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case date
        case weight
        case armMeasurement = "arm_measurement"
        case waistMeasurement = "waist_measurement"
        case bodyFatPercentage = "body_fat_percentage"
        case chestMeasurement = "chest_measurement"
    }
}

struct ProgressDiaryEntryToAPI: Encodable {
    var date: String
    var weight: Double
    var body_fat_percentage: Double?
    var arm_measurement: Double?
    var waist_measurement: Double?
    var chest_measurement: Double?
}
