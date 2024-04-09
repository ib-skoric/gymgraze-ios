//
//  EditGoalsView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 09/04/2024.
//

import SwiftUI

struct EditGoalsView: View {
    
    @EnvironmentObject var userVM: UserViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Heading(text: "Edit goals")
                
                if let stepsCount = userVM.user?.goal?.steps {
                    InputField(data: .constant(String(stepsCount)), title: "👟 Target step count per day")
                }
                
                if let exerciseMinutes = userVM.user?.goal?.exercise {
                    InputField(data: .constant(String(exerciseMinutes)), title: "🏋️‍♂️ Target exercise daily (in minutes)")
                }
                
                if let calories = userVM.user?.goal?.kcal {
                    InputField(data: .constant(String(calories)), title: "🍏 Calories to consume per day (kcal)")
                }
                
                Spacer()
                
                Button(action: {
                    // TODO: Add action code here
                }, label: {
                    Text("Save changes")
                })
                .buttonStyle(CTAButton())
                .padding()
            }
        }
    }
}

#Preview {
    EditGoalsView()
}
