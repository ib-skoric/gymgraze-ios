import SwiftUI

struct DiaryView: View {
    
    @EnvironmentObject var userVM: UserViewModel
    @ObservedObject var diaryVM = DiaryViewModel()
    @State private var selectedFood: Food?
    @State private var selectedWorkout: Workout?
    @State private var isAddFoodViewPresented: Bool = false
    @State private var isAddWorkoutViewPresented: Bool = false
    
    var foodsByMeal: [Int: [Food]] {
        Dictionary(grouping: diaryVM.diaryFoods) { $0.meal.id }
    }
    
    var body: some View {
        ZStack {
            VStack {
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
                            
                            AddToDropdown(isAddFoodViewPresented: $isAddFoodViewPresented, isAddWorkoutViewPresented: $isAddWorkoutViewPresented, type: "menu")
                        }
                    }
                    .onAppear(perform: diaryVM.fetchFoodDiary) // Fetch food diary when the view appears
                    .onAppear(perform: diaryVM.fetchWorkoutDiary) // Fetch workout diary when the view appears
                    
                    VStack {
                        if diaryVM.isLoading {
                            Spacer()
                            VStack {
                                ProgressView()
                            }
                            Spacer()
                        } else if diaryVM.diaryFoods.isEmpty && diaryVM.diaryWokrouts.isEmpty {
                            Spacer()
                            VStack {
                                Text("No entries for this date.")
                                    .font(.title)
                                    .foregroundColor(.gray)
                                AddToDropdown(isAddFoodViewPresented: $isAddFoodViewPresented, isAddWorkoutViewPresented: $isAddWorkoutViewPresented, type: "button")
                            }
                            .padding()
                            Spacer()
                        } else {
                            List {
                                if !diaryVM.diaryFoods.isEmpty {
                                    ForEach(foodsByMeal.keys.sorted(), id: \.self) { mealId in
                                        Section() {
                                            ForEach(foodsByMeal[mealId]!, id: \.id) { food in
                                                FoodDiaryRow(food: food, nutritionalInfo: food.nutritionalInfo)
                                                    .onTapGesture {
                                                        selectedFood = food
                                                    }
                                            }
                                            .onDelete(perform: { indexSet in
                                                deleteFood(mealId: mealId)
                                            })
                                        } header: {
                                            HStack {
                                                VStack {
                                                    Text(diaryVM.diaryFoods.first(where: { $0.meal.id ==  mealId })?.meal.name ?? "")
                                                }
                                                
                                                Spacer()
                                                
                                                HStack {
                                                    Text("**Kcal**: \(foodsByMeal[mealId]!.reduce(0) { $0 + $1.nutritionalInfo.kcal })")
                                                    Text("**C**: \(String(format: "%.1f", foodsByMeal[mealId]!.reduce(0) { $0 + $1.nutritionalInfo.carbs }))")
                                                    Text("**P**: \(String(format: "%.1f", foodsByMeal[mealId]!.reduce(0) { $0 + $1.nutritionalInfo.protein }))")
                                                    Text("**F**: \(String(format: "%.1f", foodsByMeal[mealId]!.reduce(0) { $0 + $1.nutritionalInfo.fat }))")
                                                }
                                            }
                                        }
                                    }
                                    .sheet(item: $selectedFood) { food in
                                        FoodDetailView(food: food)
                                            .environmentObject(diaryVM)
                                    }
                                }
                                
                                if !diaryVM.diaryWokrouts.isEmpty {
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
                    .navigationDestination(isPresented: $isAddFoodViewPresented) {
                        AddToFoodDiaryView()
                    }
                    .navigationDestination(isPresented: $isAddWorkoutViewPresented) {
                        AddToWorkoutDiaryView()
                    }
                }
            }
        }
    }
    
    func deleteFood(mealId: Int) {
        let foodToDelete = foodsByMeal[mealId]![0].id
        
        DiaryService().removeFoodItem(foodId: Int(foodToDelete)) { result in
            switch result {
            case .success(_):
                print("deleted food")
                diaryVM.fetchFoodDiary()
            case .failure(let error):
                print("Error deleting food \(error)")
            }
        }
    }
    
    #Preview {
        ContentView().environmentObject(UserViewModel())
    }
}
