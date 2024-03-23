//
//  AddToDropdown.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 22/03/2024.
//

import SwiftUI

struct AddToDropdown: View {
    
    @Binding var isAddFoodViewPresented: Bool
    @Binding var isAddWorkoutViewPresented: Bool
    var type: String
    
    var body: some View {
        Menu {
            Button(action: {
                isAddFoodViewPresented = true
            }, label: {
                Label("Add food", systemImage: "fork.knife")
            })
            
            Button(action: {
                isAddWorkoutViewPresented = true
            }, label: {
                Label("Add workout", systemImage: "figure.run")
            })
            
        } label: {
            if type == "menu" {
                Label("", systemImage: "plus")
                    .font(.system(size: 25))
                    .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.purple, .orange]), startPoint: .top, endPoint: .bottom))
            } else {
                Button(action: {}, label: {
                    Label("Add to diary", systemImage: "plus")
                }).buttonStyle(CTAButton())
                    .padding()
            }
        }
        .padding(.trailing)
    }
}

#Preview {
    AddToDropdown(isAddFoodViewPresented: .constant(false), isAddWorkoutViewPresented: .constant(false), type: "menu")
}
