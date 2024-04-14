//
//  TrendsViewModel.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 13/04/2024.
//

import Foundation
import HealthKit

class TrendsViewModel: ObservableObject {
    @Published var trends: Trends
    @Published var trendsGraphsVisible: [String: Bool] = ["Weight": true, "Body fat percentage": false, "Arm measurement": false, "Waist measurement": false, "Chest measurement": false, "Steps trend": false]
    @Published var stepsPerDay: [StepTrend] = []
    @Published var healthStore = HKHealthStore()
    
    init() {
        trends = Trends(weights: [], bodyFatPercentages: [], armMeasurements: [], waistMeasurements: [], chestMeasurements: [])
        self.stepsPerDay = fetchAppleHealthKitStepData()
        print(self.stepsPerDay)
    }
    
    func fetchTrends() {
        UserService().fetchTrends() { result in
            switch result {
            case .success(let trends):
                self.trends = trends
            case .failure(let error):
                print(error)
            }
        }
    }
    
    var stepsQuantityType: HKQuantityType {
        return HKQuantityType.quantityType(forIdentifier: .stepCount)!
    }

    var exerciseMinutesQuantityType: HKQuantityType {
        return HKQuantityType.quantityType(forIdentifier: .appleExerciseTime)!
    }
    
    func fetchAppleHealthKitStepData() -> [StepTrend] {
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
                }

                // Execute the query
                self.healthStore.execute(stepsQuery)
            }
        }
        
        return stepsPerDay
    }

}
