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
    @Binding var notification: InAppNotification?
    @State var meals: [Meal] = []
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Heading(text: "Edit meals")
                    
                    // way to add meals
                    Button {
                        // show the add meal modal
                        isAddMealModalShown.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 20))
                            .foregroundColor(.orange)
                    }
                    .padding(.trailing)
                    .accessibilityLabel("Add meal button")

                }
                
                // list to display all meals for user
                List {
                    ForEach(userVM.user?.meals ?? [], id: \.self) { meal in
                        HStack {
                            TextField("Meal Name", text: .constant(meal.name))
                                .accessibilityLabel("Meal name input field")
                        }
                    }
                    .onDelete(perform: meals.count > 1 ? deleteMeal : nil)
                }
                // on appear get meals
                .onAppear {
                    self.meals = userVM.user?.meals ?? []
                }
                
                Spacer()
            }
            // alert to handle adding a meal
            .alert("🍏 Add meal", isPresented: $isAddMealModalShown, actions: {
                TextField("Meal name", text: $newMealName)
                Button("Add", action: {
                    
                    let meal = MealToAPI(name: newMealName)
                    
                    UserService().createMeal(meal: meal) { result in
                        switch result {
                        case .success(let meal):
                            notification = InAppNotification(style: .success, message: "Meals successfully updated!")
                            userVM.fetchUser()
                        case .failure(let error):
                            print(error)
                        }
                    }
                })
                Button("Cancel", role: .cancel, action: {})
                    .accessibilityLabel("Cancel button")
            }, message: {
                Text("Create new meal")
            })
            .onDisappear {
                handleMealsUpdate()
            }
        }
    }
    
    func handleMealsUpdate() {
        let mealsToAPI: [MealToAPI]
        
        mealsToAPI = meals.map { MealToAPI(id: $0.id, name: $0.name) }

        // save changes
        userVM.updateMeals(meals: mealsToAPI) { result in
            switch result {
            case .success(let user):
                userVM.fetchUser()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func deleteMeal(at offsets: IndexSet) {
        guard let index = offsets.first else {
            print("No meal to delete")
            return
        }
        
        let mealId = userVM.user?.meals?[index].id ?? 0
        userVM.user?.meals?.remove(atOffsets: offsets)
        
        userVM.deleteMeal(id: mealId) { result in
            switch result {
            case .success:
                userVM.fetchUser()
            case .failure:
                print("Failed to delete meal")
            }
        }
    }
}
