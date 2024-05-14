//
//  MainViewModel.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 13/04/2024.
//

import Foundation
import HealthKit

class MainViewModel: ObservableObject {
    /// Published properties used by different views to update UI
    @Published var healthStore = HKHealthStore()
    @Published var steps: Double = 0
    @Published var exerciseMinutes: Double = 0
    @Published var totalKcal: Double = 0
    @Published var randomCards: [ArticleCard] = []
    
    // variable for storing article card data
    var articleCards: [ArticleCard] = [ArticleCard(image: "cardio-or-weights", title: "Cardio or weights first?", body: "So, you’re wondering whether to hit the treadmill or the dumbbells first, right?\n\nWell, it’s all about what makes you feel awesome and matches your goals. If you’re looking to get that heart pumping and feel the burn, starting with a bit of cardio is like a warm hug for your muscles, getting them ready for action. But if you’re all about flexing those muscles and getting stronger, lifting weights first is like giving your muscles the VIP treatment they deserve. And hey, why not mix it up? Some days you can be the cardio king or queen, and other days, the weight room can be your castle.\n\nThe gym’s your playground, so have fun with it and do what feels good for you! 🏋️‍♂️🏃‍♀️"),
                                       ArticleCard(image: "calendar", title: "How often should I work out?", body: "Welcome to the fitness family! Starting your gym journey is like planting a garden – you need to nurture it regularly, but not so much that it overwhelms you.\n\nFor beginners, hitting the gym 3-4 days a week is a great way to get your feet wet without diving into the deep end too fast. It’s like meeting new friends – you want to hang out enough to build the friendship, but not so much that you run out of things to talk about. On your off days, don’t forget to rest and recover. Your muscles are like batteries; they need time to recharge!"),
                                       ArticleCard(image: "protein-shakes", title: "Do I really need a protein shake?", body: "Protein shakes are like the fast food of the fitness world – quick, convenient, and packed with nutrients.\n\nBut just like fast food, they’re not a must-have; they’re just one option on the menu. If you’re rushing from the gym to your next adventure and need a quick muscle fix, a shake can be super handy. But if you’ve got time to whip up a meal or prefer munching on real foods, that’s cool too. Your body is pretty awesome at using whatever protein you give it, whether it’s from a shake or a steak."),
                                        ArticleCard(image: "right-weight", title: "What weight should I be lifting?", body: "Finding the right weight is like finding the perfect pair of jeans – it might take some trial and error, but when you find it, you just know.\n\nStart light and focus on nailing your form, like practicing your dance moves before hitting the club. As you get more comfortable, gradually increase the weight. The last few reps should feel challenging but not impossible – like a good brain teaser. And remember, it’s totally okay to ask for a spotter or help from a trainer. Safety first!"),
                                        ArticleCard(image: "healthy-food", title: "Food - before or after the gym?", body: "Fueling up before the gym is like putting gas in your car before a road trip – it keeps you going and prevents you from sputtering to a stop.\n\nA snack like a banana or a small yogurt about 30 minutes before your workout can give you that zing of energy. After your workout, it’s time to refuel. Eating a mix of carbs and protein within an hour after exercising helps repair and grow those muscles. Think of it as the repair crew coming in after a wild party – they clean up and set everything right again."),
                                        ArticleCard(image: "gym-machines", title: "Which machines should I start with?", body: "The gym is like an amusement park for adults – so many rides, so little time!\n\nStart with machines that align with your goals. If you’re looking to build strength, the resistance machines are like your personal trainers, guiding you through each move. For cardio, the treadmill, elliptical, or bike can be your concert stage – where you’re the star running to the beat. And don’t be shy to ask for a demo from the gym staff. They’re like the friendly park guides, ready to show you the ropes!")]
    
    /// Initialiser
    init() {
        randomCards = shuffleCards(articleCards)
    }

    // HealthKit quantity type for steps
    var stepsQuantityType: HKQuantityType {
        return HKQuantityType.quantityType(forIdentifier: .stepCount)!
    }
    
    // HealthKit quantity type for exercise minutes
    var exerciseMinutesQuantityType: HKQuantityType {
        return HKQuantityType.quantityType(forIdentifier: .appleExerciseTime)!
    }
    
    /// Method for fetching the data from HealthKit
    func fetchData() {
        // Check authorization status
        let dataTypes: Set = [stepsQuantityType, exerciseMinutesQuantityType]

        // request permission to use HealtKit data
        healthStore.requestAuthorization(toShare: [], read: dataTypes) { (success, error) in
            if success {
                // Get today's date
                let calendar = Calendar.current
                let startOfDay = calendar.startOfDay(for: Date())
                let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictStartDate)
                let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()])
                let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, devicePredicate])

                // Define the query
                let stepsQuery = HKSampleQuery(sampleType: self.stepsQuantityType, predicate: compoundPredicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, results, error) in
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
    
    /// Method for fetching the food summary
    func fetchFoodSummary() {
        
        // Call diary service and fetch foods
        DiaryService().fetchFoodSummary { result in
            switch result {
            case .success(let foodSummary):
                self.totalKcal = foodSummary.kcal
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    /// Method for shuffling the cards in the array
    func shuffleCards(_ cards: [ArticleCard]) -> [ArticleCard] {
        return Array(cards.shuffled().prefix(3))
    }
}

