//
//  DiaryView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 18/02/2024.
//

import SwiftUI

struct DiaryView: View {
    
    @EnvironmentObject var userVM: UserViewModel
    @ObservedObject var diaryVM = DiaryViewModel()
    @State var selectedDate: Date = Date()
    
    var body: some View {
        NavigationStack {
            
            VStack {
                HStack {
                    Heading(text: "📒 Diary")
                    Spacer()
                    DatePicker(selection: $selectedDate, displayedComponents: .date) {
                        EmptyView()
                    }
                    .padding(.trailing)
                }
            }
            
            List {
                if let meals = userVM.user?.meals {
                    ForEach(meals, id: \.self) {meal in
                        Section(header: Text(meal.name)) {
                                DiaryRow(foodName: "Apple", foodWeightInG: 150.0, nutritionalInfo: "C: 20, P:0, F:0", kcal: 120)
                                DiaryRow(foodName: "Cereal", foodWeightInG: 175.0, nutritionalInfo: "C: 35, P:1, F:7", kcal: 250)
                        }
                    }
                }
            }
            
            Button(action: {
                fetchFoodDiary()
            }, label: {
                Text("Fetch Food Diary")})
        }
    }
    
    func fetchFoodDiary() {
        FoodDiaryService().fetchFoodDiaryEntry() { result in
            switch result {
            case .success(let entry):
                print(entry)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

#Preview {
    ContentView().environmentObject(UserViewModel())
}
