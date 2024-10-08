//
//  DiaryViewModel.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 10/03/2024.
//

import Foundation

class DiaryViewModel: ObservableObject {
    /// Published properties used by different views to update UI
    @Published var selectedDate: Date = Date()
    @Published var diaryFoods: [Food] = FoodDiaryEntry().foods
    @Published var diaryWokrouts: [Workout] = WorkoutDiaryEntry().workouts
    @Published var diaryProgressEntry: [ProgressDiaryEntry]? = nil
    @Published var isLoading = false
    @Published var workoutFetchCompleted: Bool = false
    
    /// Method for refreshign the diary
    func refresh() {
        self.isLoading = true
        self.fetchFoodDiary()
        self.fetchWorkoutDiary()
        self.fetchProgressDiary()
        self.isLoading = false
    }
    
    /// Method for fetching the food diary for the selected date
    func fetchFoodDiary() {
        self.isLoading = true
        
        // format the date required for the API
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let dateString = dateFormatter.string(from: selectedDate)
        
        // call the API service to fetch the food diary
        DiaryService().fetchFoodDiaryEntry(date: dateString) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let entry):
                    self.diaryFoods = entry.foods
                    self.workoutFetchCompleted = true
                    print(entry)
                    self.isLoading = false
                case .failure(let error):
                    if case APIError.entryNotFound = error {
                        print("Ran into 404 error, returning empty array...")
                        self.diaryFoods = []
                    } else {
                        print(error)
                    }
                    self.isLoading = false
                }
            }
        }
    }
    
    /// Method for fetching the workout diary for the selected date
    func fetchWorkoutDiary() {
        self.isLoading = true
        
        // format the date required for the API
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let dateString = dateFormatter.string(from: selectedDate)
        
        // call the API service to fetch the workout diary
        DiaryService().fetchWorkoutDiaryEntry(date: dateString) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let entry):
                    self.diaryWokrouts = entry.workouts
                    print("Diary workouts after fetching: ", self.diaryWokrouts)
                    self.isLoading = false
                case .failure(let error):
                    if case APIError.entryNotFound = error {
                        print("Ran into 404 error, returning empty array...")
                        self.diaryWokrouts = []
                    } else {
                        print(error)
                    }
                    self.isLoading = false
                }
            }
        }
    }
    
    /// Method for fetching the progress diary for the selected date
    func fetchProgressDiary() {
        self.diaryProgressEntry = nil
        self.isLoading = true
        
        // format the date required for the API
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let dateString = dateFormatter.string(from: selectedDate)
        
        // call the API service to fetch the progress diary
        DiaryService().fetchProgressDiaryEntry(date: dateString) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let entry):
                    self.diaryProgressEntry = [entry]
                    self.isLoading = false
                case .failure(let error):
                    if case APIError.entryNotFound = error {
                        self.diaryProgressEntry = nil
                        print("Ran into 404 error, returning empty array of progress...")
                    } else {
                        print(error)
                    }
                    self.isLoading = false
                }
            }
        }
    }
    
    /// Method for adding progress entry to the diary
    func addToProgressDiary(progressDiaryEntry: ProgressDiaryEntryToAPI, completion: @escaping (Result<Bool, APIError>) -> Void) {
        self.isLoading = true
        
        // call the API service to add the progress entry to the diary
        DiaryService().addToProgressDiary(progressDiaryEntry: progressDiaryEntry) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    completion(.success(true))
                    self.isLoading = false
                case .failure(let error):
                    print(error)
                    completion(.failure(APIError.custom(errorMessage: "Something went wrong")))
                    self.isLoading = false
                }
            }
        }
    }
}
