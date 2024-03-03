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
            }
            .padding(.top)
            Spacer()
            // check current step count
            if step < steps.count {
                VStack {
                    Text(steps[step].question)
                        .multilineTextAlignment(.center)
                        .font(.subheadline)
                    InputField(data: steps[step].binding, title: steps[step].placeholder)
                        .accessibilityLabel("\(steps[step].placeholder) input field")
                    if !steps[step].error.wrappedValue.isEmpty {
                        Text(steps[step].error.wrappedValue)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
                .transition(.push(from: .trailing))
            } else {
                // Vstack for the last step of the registration process
                VStack {
                    Text("Nice one!\n\n Let's go smash some goals!\n")
                        .multilineTextAlignment(.center)
                        .font(.headline)
                }
                .transition(.push(from: .trailing))
            }
            Spacer()
            // conditionally display different buttons
            if step < steps.count {
                Button(action: {
                    if validateField(step: step) {
                        withAnimation {
                            step += 1
                        }
                    }
                }, label: {
                    Text("Next")
                }).buttonStyle(CTAButton())
                    .padding()
                    .accessibilityLabel("Next step button")
            } else {
                Button(action: {
                    if validateAllFields() {
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
                }, label: {
                    if isLoading {
                        ProgressView()
                    } else {
                        Text("Finish set up")
                    }
                }).buttonStyle(CTAButton())
                    .padding()
                    .accessibilityLabel("Sign up button")
                    .navigationDestination(isPresented: $showContentView) {
                        ContentView()
                            .navigationBarBackButtonHidden(true)
                    }
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
    
    func validateAllFields() -> Bool {
        var allValid = true
        for i in 0..<steps.count {
            if !validateField(step: i) {
                allValid = false
            }
        }
        return allValid
    }
}

#Preview {
    SetGoalsView()
}
