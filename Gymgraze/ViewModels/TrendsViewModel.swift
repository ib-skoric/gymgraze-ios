//
//  TrendsViewModel.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 13/04/2024.
//

import Foundation
import HealthKit

class TrendsViewModel: ObservableObject {
    /// Published properties used by different views to update UI
    @Published var trends: Trends
    @Published var trendsGraphsVisible: [String: Bool] = ["Weight": false, "Body fat percentage": false, "Arm measurement": false, "Waist measurement": false, "Chest measurement": false, "Steps trend": true]
    @Published var stepsPerDay: [StepTrend] = []
    @Published var healthStore = HKHealthStore()
    
    /// Initialiser
    init() {
        trends = Trends(weights: [], bodyFatPercentages: [], armMeasurements: [], waistMeasurements: [], chestMeasurements: [])
        fetchAppleHealthKitStepData { stepsPerDay in
            self.stepsPerDay = stepsPerDay
        }
        print(self.stepsPerDay)
    }
    
    /// Method for fetching trends
    func fetchTrends() {
        
        // call user service to fetch trends
        UserService().fetchTrends() { result in
            switch result {
            case .success(let trends):
                self.trends = trends
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // HealthKit quantity type for steps
    var stepsQuantityType: HKQuantityType {
        return HKQuantityType.quantityType(forIdentifier: .stepCount)!
    }

    // HealthKit quantity type for exercise minutes
    var exerciseMinutesQuantityType: HKQuantityType {
        return HKQuantityType.quantityType(forIdentifier: .appleExerciseTime)!
    }
    
    /// Method for fetching step data from Apple HealthKit
    func fetchAppleHealthKitStepData(completion: @escaping ([StepTrend]) -> Void) {
        // Check authorization status
        let dataTypes: Set = [stepsQuantityType]

        healthStore.requestAuthorization(toShare: [], read: dataTypes) { (success, error) in
            if success {
                // Get the start and end date for the range you want to fetch
                let calendar = Calendar.current
                let endDate = calendar.startOfDay(for: Date())
                let startDate = calendar.date(byAdding: .day, value: -7, to: endDate) // Change this to fetch more days

                let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)

                // Define the query
                let stepsQuery = HKStatisticsCollectionQuery(quantityType: self.stepsQuantityType,
                                                             quantitySamplePredicate: predicate,
                                                             options: [.cumulativeSum],
                                                             anchorDate: startDate ?? Date(),
                                                             intervalComponents: DateComponents(day: 1))

                stepsQuery.initialResultsHandler = { query, results, error in
                    if let statsCollection = results {
                        statsCollection.enumerateStatistics(from: startDate ?? Date(), to: endDate) { statistics, _ in
                            if let quantity = statistics.sumQuantity() {
                                let steps = quantity.doubleValue(for: HKUnit.count())
                                let date = statistics.startDate
                                self.stepsPerDay.append(StepTrend(date: date, steps: steps))
                            }
                        }
                    }
                    // Call the completion handler with the steps per day
                    completion(self.stepsPerDay)
                }

                // Execute the query
                self.healthStore.execute(stepsQuery)
            }
        }
    }
}
