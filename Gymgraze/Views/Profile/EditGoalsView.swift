//
//  EditGoalsView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 09/04/2024.
//

import SwiftUI

struct EditGoalsView: View {
    
    @State var stepsCount: String = ""
    @State var exerciseMinutes: String = ""
    @State var calories: String = ""
    @Binding var notification: InAppNotification?
    @EnvironmentObject var userVM: UserViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Heading(text: "Edit goals")
                
                InputField(data: $stepsCount, title: "👟 Target step count per day")
                
                InputField(data: $exerciseMinutes, title: "🏋️‍♂️ Target exercise daily (in minutes)")
                
                InputField(data: $calories, title: "🍏 Calories to consume per day (kcal)")
                
                Spacer()
            }
            .onAppear {
                self.stepsCount = String(userVM.user?.goal?.steps ?? 0)
                self.exerciseMinutes = String(userVM.user?.goal?.exercise ?? 0)
                self.calories = String(userVM.user?.goal?.kcal ?? 0)
            }
            .onDisappear {
                handleGoalUpdate()
            }
        }
    }
    
    func handleGoalUpdate() {
        let goalPayload =
            GoalPayload(
                kcal: Int(calories) ?? 0,
                steps: Int(stepsCount) ?? 0,
                exercise: Int(exerciseMinutes) ?? 0
            )
        userVM.updateGoals(goal: goalPayload) { result in
            
            switch result {
            case .success:
                notification = InAppNotification(style: .success, message: "Goals successfully updated!")
                print("Successfully updated goals")
            case .failure:
                print("Failed to update goals")
            }
        }
    }
}


//#Preview {
//    EditGoalsView()
//}
