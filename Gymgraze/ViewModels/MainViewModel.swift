//
//  MainViewModel.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 13/04/2024.
//

import Foundation
import HealthKit

class MainViewModel: ObservableObject {
    @Published var healthStore = HKHealthStore()
    @Published var steps: Double = 0
    @Published var exerciseMinutes: Double = 0

    var stepsQuantityType: HKQuantityType {
        return HKQuantityType.quantityType(forIdentifier: .stepCount)!
    }

    var exerciseMinutesQuantityType: HKQuantityType {
        return HKQuantityType.quantityType(forIdentifier: .appleExerciseTime)!
    }

    func fetchData() {
        // Check authorization status
        let dataTypes: Set = [stepsQuantityType, exerciseMinutesQuantityType]

        healthStore.requestAuthorization(toShare: [], read: dataTypes) { (success, error) in
            if success {
                // Get today's date
                let calendar = Calendar.current
                let startOfDay = calendar.startOfDay(for: Date())
                let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictStartDate)

                // Define the query
                let stepsQuery = HKSampleQuery(sampleType: self.stepsQuantityType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, results, error) in
                    if let results = results as? [HKQuantitySample] {
                        let totalSteps = results.map { $0.quantity.doubleValue(for: HKUnit.count()) }.reduce(0, +)
                        self.steps = totalSteps
                    }
                }

                let exerciseMinutesQuery = HKSampleQuery(sampleType: self.exerciseMinutesQuantityType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, results, error) in
                    if let results = results as? [HKQuantitySample] {
                        let totalExerciseMinutes = results.map { $0.quantity.doubleValue(for: HKUnit.minute()) }.reduce(0, +)
                        self.exerciseMinutes = totalExerciseMinutes
                    }
                }

                // Execute the queries
                self.healthStore.execute(stepsQuery)
                self.healthStore.execute(exerciseMinutesQuery)
            }
        }
    }
}

