import SwiftUI

struct DiaryView: View {
    
    @EnvironmentObject var userVM: UserViewModel
    @ObservedObject var diaryVM = DiaryViewModel()
    @State private var selectedFood: Food?
    @State private var selectedWorkout: Workout?
    @State private var isAddFoodViewPresented: Bool = false
    @State private var isAddWorkoutViewPresented: Bool = false
    @State private var isWorkoutDetailsActive: Bool = false
    @State var selectedDate: Date?
    
    var foodsByMeal: [Int: [Food]] {
        Dictionary(grouping: diaryVM.diaryFoods) { $0.meal.id }
    }
    
    init(selectedDate: Date? = nil) {
        if selectedDate != nil {
            diaryVM.selectedDate = selectedDate!
        }
    }
    
    var body: some View {
        VStack {
            NavigationStack {
                VStack {
                    viewHeading
                }
                .onAppear {
                    DispatchQueue.main.async {
                        diaryVM.refresh()
                    }
                }
                VStack {
                    if diaryVM.isLoading {
                        Spacer()
                        VStack {
                            ProgressView()
                        }
                        Spacer()
                    } else if diaryVM.diaryFoods.isEmpty && diaryVM.diaryWokrouts.isEmpty && diaryVM.diaryProgressEntry == nil {
                        Spacer()
                        noEtriesView
                        Spacer()
                    } else {
                        List {
                            if diaryVM.diaryProgressEntry != nil {
                                Section() {
                                    ProgressDiaryRow(progressDiaryEntry: diaryVM.diaryProgressEntry ?? ProgressDiaryEntry())
                                }
                            }
                            
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
                                                Text("**Kcal**: \(foodsByMeal[mealId]!.reduce(0) { $0 + $1.totalNutrition.kcal })")
                                                Text("**C**: \(String(format: "%.1f", foodsByMeal[mealId]!.reduce(0) { $0 + $1.totalNutrition.carbs }))")
                                                Text("**P**: \(String(format: "%.1f", foodsByMeal[mealId]!.reduce(0) { $0 + $1.totalNutrition.protein }))")
                                                Text("**F**: \(String(format: "%.1f", foodsByMeal[mealId]!.reduce(0) { $0 + $1.totalNutrition.fat }))")
                                            }
                                        }
                                    }
                                }
                            }
                            
                            
                            if !diaryVM.diaryWokrouts.isEmpty {
                                Section() {
                                    ForEach(diaryVM.diaryWokrouts, id: \.id) { workout in
                                        WorkoutDiaryRow(workout: workout)
                                            .onTapGesture {
                                                if self.selectedWorkout == nil {
                                                    DispatchQueue.main.async {
                                                        self.selectedWorkout = workout
                                                    }
                                                }
                                            }
                                    }
                                }
                                .foregroundColor(.orange)
                                
                            }
                        }
                        .sheet(item: $selectedFood) { food in
                            FoodDetailView(food: food)
                                .environmentObject(diaryVM)
                        }
                        .sheet(item: $selectedWorkout) { workout in
                            WorkoutDetailView(workout: workout)
                        }
                    }
                }
            }
        }
    }
    
    private var viewHeading: some View {
        HStack {
            Heading(text: "📒 Diary")
            Spacer()
            DatePicker(selection: $diaryVM.selectedDate, displayedComponents: .date) {
                EmptyView()
            }
            .onChange(of: diaryVM.selectedDate) { newValue, oldValue in
                DispatchQueue.main.async {
                    if newValue != oldValue {
                        selectedDate = newValue
                        diaryVM.fetchFoodDiary()
                        diaryVM.fetchWorkoutDiary()
                        diaryVM.fetchProgressDiary()
                    }
                }
            }
            
            AddToDropdown(type: "menu", date: $diaryVM.selectedDate)
        }
    }
    
    
    private var noEtriesView: some View {
        VStack {
            Text("No entries for this date.")
                .font(.title)
                .foregroundColor(.gray)
            AddToDropdown(type: "button", date: $diaryVM.selectedDate)
        }
        .padding()
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
