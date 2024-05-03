import SwiftUI

struct DiaryView: View {
    
    @EnvironmentObject var userVM: UserViewModel
    @ObservedObject var diaryVM = DiaryViewModel()
    @State private var selectedFood: Food?
    @State private var selectedWorkout: Workout?
    @State private var isAddFoodViewPresented: Bool = false
    @State private var isAddWorkoutViewPresented: Bool = false
    @State private var isWorkoutDetailsActive: Bool = false
    @State private var isGenieActive: Bool = false
    @State var selectedDate: Date?
    @State private var notification: InAppNotification? = nil

    var foodsByMeal: [Int: [Food]] {
        Dictionary(grouping: diaryVM.diaryFoods) { $0.meal.id }
    }
    
    init(selectedDate: Date? = nil, notification: State<InAppNotification?>) {
        if selectedDate != nil {
            diaryVM.selectedDate = selectedDate!
        }
        self._notification = notification
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
                            if !(diaryVM.diaryProgressEntry?.isEmpty ?? true) {
                                Section() {
                                    ForEach(diaryVM.diaryProgressEntry!, id: \.id) { entry in
                                        ProgressDiaryRow(progressDiaryEntry: entry)
                                    }
                                    .onDelete(perform: { indexSet in
                                        deleteProgressEntry()
                                    })
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
                                    .onDelete(perform: { indexSet in
                                        deleteWorkout(indexSet: indexSet)
                                    })
                                }
                                .foregroundColor(.orange)
                                
                            }
                        }
                        .sheet(item: $selectedFood) { food in
                            FoodDetailView(food: food, notification: $notification)
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
                        print("Selected diaryVM date: \(diaryVM.selectedDate)")
                        diaryVM.fetchFoodDiary()
                        diaryVM.fetchWorkoutDiary()
                        diaryVM.fetchProgressDiary()
                    }
                }
            }
            
            Button(action: {
                print("GenieAI button presses")
                self.isGenieActive.toggle()
            }) {
                Image(systemName: "wand.and.stars")
            }
            .font(.system(size: 20))
            .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.purple, .orange]), startPoint: .top, endPoint: .bottom))
            
            AddToDropdown(type: "menu", date: $diaryVM.selectedDate)
                .environmentObject(diaryVM)
        }
        .sheet(isPresented: $isGenieActive) {
            GenieAIView()
        }
    }
    
    
    private var noEtriesView: some View {
        VStack {
            Text("No entries for this date.")
                .font(.title)
                .foregroundColor(.gray)
            AddToDropdown(type: "button", date: $diaryVM.selectedDate)
                .environmentObject(diaryVM)
        }
        .padding()
    }
    
    
    func deleteFood(mealId: Int) {
        let foodToDelete = foodsByMeal[mealId]![0].id

        DiaryService().removeFoodItem(foodId: Int(foodToDelete)) { result in
            switch result {
            case .success(_):
                print("deleted food")
                DispatchQueue.main.async {
                    diaryVM.fetchFoodDiary()
                }
            case .failure(let error):
                print("Error deleting food \(error)")
            }
        }
    }
    
    func deleteProgressEntry() {
        let entryToDelete = diaryVM.diaryProgressEntry![0].id
        
        DiaryService().deleteProgressEntry(id: Int(entryToDelete)) { result in
            switch result {
            case .success(_):
                print("deleted progress entry")
                diaryVM.fetchProgressDiary()
            case .failure(let error):
                print("Error deleting progress entry \(error)")
            }
        }
    }
    
    func deleteWorkout(indexSet: IndexSet) {
        
        let workoutToDelete = diaryVM.diaryWokrouts[indexSet.first!].id
        
        DiaryService().deleteWorkoutEntry(id: Int(workoutToDelete)) { result in
            switch result {
            case .success(_):
                print("deleted workout")
                diaryVM.fetchWorkoutDiary()
            case .failure(let error):
                print("Error deleting workout \(error)")
            }
        }
    }
    
    #Preview {
        ContentView().environmentObject(UserViewModel())
    }
}
