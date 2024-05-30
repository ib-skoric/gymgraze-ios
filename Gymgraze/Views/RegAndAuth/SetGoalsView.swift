//
//  SetGoalsView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 02/03/2024.
//

import SwiftUI

import SwiftUI

struct SetGoalsView: View {
    // ----- Variables -----
    @State var stepsCount: String = ""
    @State var exercise: String = ""
    @State var kcal: String = ""
    
    // variables for error handling
    @State var stepsCountError: String = ""
    @State var exerciseError: String = ""
    @State var kcalError: String = ""
    
    // variables for UI handling
    @State var isLoading: Bool = false
    @State var showContentView: Bool = false
    
    // view model
    @EnvironmentObject var userVM: UserViewModel

    
    var body: some View {
        NavigationStack {
            // Main Vstack
            VStack {
                Text("🎯 Let's set some goals!")
                    .multilineTextAlignment(.center)
                    .font(.title)
                    .fontWeight(.bold)
                Text("It's important to have goals and boxes to tick.")
                    .multilineTextAlignment(.center)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.top)
            
            Spacer()
            
            VStack {
                InputField(data: $stepsCount, title: "👟 Target step count per day")
                    .padding(.bottom)
                    .accessibilityLabel("Target step count input field")
                Text(stepsCountError)
                    .multilineTextAlignment(.center)
                    .font(.subheadline)
                    .foregroundColor(.red)
                
                InputField(data: $exercise, title: "🏋️‍♂️ Target exercise daily (in minutes)")
                    .padding(.bottom)
                    .accessibilityLabel("Target exercise daily field")
                Text(exerciseError)
                    .multilineTextAlignment(.center)
                    .font(.subheadline)
                    .foregroundColor(.red)
                
                InputField(data: $kcal, title: "🍏 Calories to consume per day (kcal)")
                    .padding(.bottom)
                    .accessibilityLabel("Calories to consume per day field")
                Text(kcalError)
                    .multilineTextAlignment(.center)
                    .font(.subheadline)
                    .foregroundColor(.red)
            }
            
            
            Text("P.S. You can always change these later.")
                .multilineTextAlignment(.center)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Spacer()
            
            Button(action: {
                if validateFields() {
                    setGoals()
                }
            }, label: {
                if isLoading {
                    ProgressView()
                } else {
                    Text("Finish set up")
                }
            }).buttonStyle(CTAButton())
                .padding()
                .accessibilityLabel("Finish set up button")
                .background {
                    NavigationLink(destination: ContentView().navigationBarBackButtonHidden(true), isActive: $showContentView) {}
                }
            
        }
    }
    
    /// function that validates all fields have value and values are valid
    func validateFields() -> Bool {
        var isValid: Bool = false
        
        if stepsCount.isEmpty || Int(stepsCount)! < 1 {
            stepsCountError = "Step count can't be empty of less than 1"
        } else if (exercise.isEmpty || Int(exercise)! < 1) {
            exerciseError = "Exercise minutes can't be empty of less than 1"
        } else if (kcal.isEmpty || Int(kcal)! < 100) {
            kcalError = "Calories goal can't be empty of less than 100"
        } else {
            isValid = true
        }
        
        return isValid
        
    }
    
    // function to handle setting goals via API
    func setGoals() {
        isLoading = true
        // convert string values to int
        let stepsCountInt = Int(stepsCount) ?? 0
        let exerciseInt = Int(exercise) ?? 0
        let kcalInt = Int(kcal) ?? 0
        let goal = GoalPayload(kcal: kcalInt, steps: stepsCountInt, exercise: exerciseInt)
        userVM.setGoal(goal: goal) { result in
            switch result {
            case .success(_):
                showContentView = true
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}

#Preview {
    SetGoalsView()
}
