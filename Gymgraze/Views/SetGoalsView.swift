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
    @State var step: Int = 0
    
    // view model
    @EnvironmentObject var userVM: UserViewModel
    
    // Object to store registration steps
    struct Step {
        let question: String
        let placeholder: String
        let binding: Binding<String>
        let error: Binding<String>
    }
    
    // array to hold all steps
    var steps: [Step] {
        [
            Step(question: "👟 What do you want to be your steps goal to be?", placeholder: "Steps", binding: $stepsCount, error: $stepsCountError),
            Step(question: "🏋️‍♂️ What do you want to be your exercise goal to be?", placeholder: "Exercise", binding: $exercise, error: $exerciseError),
            Step(question: "🍏 What do you want to be your calories goal to be?", placeholder: "Calories (kcal)", binding: $kcal, error: $kcalError),
        ]
    }
    
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
                InputField(data: $exercise, title: "🏋️‍♂️ Target exercise daily (in minutes)")
                    .padding(.bottom)
                InputField(data: $stepsCount, title: "🍏 Calories to consume per day (kcal)")
                    .padding(.bottom)
                
                Text("You can always change these later.")
                    .multilineTextAlignment(.center)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Button(action: {
                setGoals()
            }, label: {
                if isLoading {
                    ProgressView()
                } else {
                    Text("Finish set up")
                }
            }).buttonStyle(CTAButton())
                .padding()
                .accessibilityLabel("Finish set up button")
                .navigationDestination(isPresented: $showContentView) {
                    ContentView()
                        .navigationBarBackButtonHidden(true)
                }
            
        }
    }
    
    func validateField(step: Int) -> Bool {
        let value = steps[step].binding.wrappedValue
        
        var isValid: Bool = false
        
        // validates if the field is not empty
        if value.isEmpty {
            steps[step].error.wrappedValue = "This field cannot be empty"
        } else {
            steps[step].error.wrappedValue = ""
            isValid = true
        }
        
        return isValid
        
    }
    
    func setGoals() {
        isLoading = true
        // convert string values to int
        let stepsCountInt = Int(stepsCount) ?? 0
        let exerciseInt = Int(exercise) ?? 0
        let kcalInt = Int(kcal) ?? 0
        // TODO: Create a goal object here
        let goal = GoalPayload(kcal: kcalInt, steps: stepsCountInt, exercise: exerciseInt)
        // TODO: Add in method to set the goal here
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
