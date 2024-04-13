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
    var armMeasurement: Double
    var waistMeasurement: Double
    var hipMeasurement: Double
    var chestMeasurement: Double
    
    init() {
        id = 0
        date = ""
        weight = 0
        armMeasurement = 0
        waistMeasurement = 0
        hipMeasurement = 0
        chestMeasurement = 0
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case date
        case weight
        case armMeasurement = "arm_measurement"
        case waistMeasurement = "waist_measurement"
        case hipMeasurement = "hip_measurement"
        case chestMeasurement = "chest_measurement"
    }
}
