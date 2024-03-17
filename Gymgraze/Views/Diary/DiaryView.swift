import SwiftUI

struct DiaryView: View {
    
    @EnvironmentObject var userVM: UserViewModel
    @ObservedObject var diaryVM = DiaryViewModel()
    @State private var selectedFood: Food?
    @State private var selectedWorkout: Workout?
    @State private var isAddViewPresented: Bool = false
    
    var foodsByMeal: [Int: [Food]] {
        Dictionary(grouping: diaryVM.diaryFoods) { $0.meal.id }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Heading(text: "📒 Diary")
                    Spacer()
                    DatePicker(selection: $diaryVM.selectedDate, displayedComponents: .date) {
                        EmptyView()
                    }
                    .onChange(of: diaryVM.selectedDate) { newValue, oldValue in
                        if newValue != oldValue {
                            diaryVM.fetchFoodDiary()
                            diaryVM.fetchWorkoutDiary()
                        }
                    }
                    
                    Button(action: {
                        isAddViewPresented = true
                    }, label: {
                        Image(systemName: "plus")
                            .font(.system(size: 25))
                    })
                    .background {
                        NavigationLink(
                            destination: AddFoodView(),
                            isActive: $isAddViewPresented,
                            label: {
                                EmptyView()
                            })
                    }
                    .padding(.trailing)
                    
                }
            }
            .onAppear(perform: diaryVM.fetchFoodDiary) // Fetch food diary when the view appears
            .onAppear(perform: diaryVM.fetchWorkoutDiary) // Fetch food diary when the view appears
            
            if diaryVM.diaryFoods.isEmpty && diaryVM.diaryWokrouts.isEmpty {
                VStack {
                    Spacer()
                    Text("No diary entries for this day")
                    Spacer()
                }
            } else {
                VStack {
                    List {
                        ForEach(foodsByMeal.keys.sorted(), id: \.self) { mealId in
                            Section(header: Text(diaryVM.diaryFoods.first(where: { $0.meal.id ==  mealId })?.meal.name ?? "")) {
                                ForEach(foodsByMeal[mealId]!, id: \.id) { food in
                                    FoodDiaryRow(foodName: food.name, foodWeightInG: 100.0, nutritionalInfo: food.nutritionalInfo)
                                        .onTapGesture {
                                            selectedFood = food
                                        }
                                }
                            }
                        }
                        .sheet(item: $selectedFood) { food in
                            FoodDetailView(food: food)
                        }
                        
                        Section("Workout Diary") {
                            ForEach(diaryVM.diaryWokrouts, id: \.id) { workout in
                                WorkoutDiaryRow(workout: workout)
                                    .onTapGesture {
                                    selectedWorkout = workout
                                }
                            }
                        }
                        // TODO: Remove this
                        .foregroundColor(.green)
                        .sheet(item: $selectedWorkout) { workout in
                            WorkoutDetailView(workout: workout)
                        }
                    }
                }
            }
        }
    }
    
    #Preview {
        ContentView().environmentObject(UserViewModel())
    }
}
