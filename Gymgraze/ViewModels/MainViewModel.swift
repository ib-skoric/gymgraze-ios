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
    @Published var totalKcal: Double = 0
    @Published var randomCards: [ArticleCard] = []
    
    var articleCards: [ArticleCard] = [ArticleCard(image: "test", title: "Cardio or weights?", subheading: "What should you do first?", description: "Article card1", body: "test1"),
                                       ArticleCard(image: "test", title: "Article card2", subheading: "Article card2", description: "Article card2", body: "test2"),
                                       ArticleCard(image: "test", title: "Article card3", subheading: "Article card3", description: "Article card3", body: "test3"),
                                        ArticleCard(image: "test", title: "Article card4", subheading: "Article card4", description: "Article card4", body: "test4"),
                                        ArticleCard(image: "test", title: "Article card5", subheading: "Article card5", description: "Article card5", body: "test5"),
                                        ArticleCard(image: "test", title: "Article card6", subheading: "Article card6", description: "Article card6", body: "test6")]
    
    init() {
        randomCards = shuffleCards(articleCards)
    }

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
    
    func fetchFoodSummary() {
        DiaryService().fetchFoodSummary { result in
            switch result {
            case .success(let foodSummary):
                self.totalKcal = foodSummary.kcal
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func shuffleCards(_ cards: [ArticleCard]) -> [ArticleCard] {
        return Array(cards.shuffled().prefix(3))
    }
}

