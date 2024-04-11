//
//  EditMealsview.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 09/04/2024.
//

import SwiftUI

struct EditMealsview: View {
    
    @EnvironmentObject var userVM: UserViewModel
    @State var isAddMealModalShown: Bool = false
    @State var newMealName: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Heading(text: "Edit meals")
                    
                    Button {
                        // show the add meal modal
                        isAddMealModalShown.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 20))
                            .foregroundColor(.orange)
                    }

                }
                
                List(userVM.user?.meals ?? []) { meal in
                    HStack {
                        TextField(meal.name, text: .constant(meal.name))
                    }
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
            .alert("🍏 Add meal", isPresented: $isAddMealModalShown, actions: {
                TextField("Meal name", text: $newMealName)
                Button("Add", action: {
                    
                    let meal = MealToAPI(name: newMealName)
                    
                    UserService().createMeal(meal: meal) { result in
                        switch result {
                        case .success(let meal):
                            userVM.fetchUser()
                        case .failure(let error):
                            print(error)
                        }
                    }
                })
                Button("Cancel", role: .cancel, action: {})
            }, message: {
                Text("Create new cardio exercise")
            })
        }
    }
}

#Preview {
    EditMealsview()
}
