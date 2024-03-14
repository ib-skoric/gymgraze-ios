import SwiftUI

struct DiaryView: View {
    
    @EnvironmentObject var userVM: UserViewModel
    @ObservedObject var diaryVM = DiaryViewModel()
    @State var selectedDate: Date = Date()
    @State private var selectedFood: Food?
    @State private var isDetailViewPresented: Bool = false
    
    @State var diaryFoods: [Food] = FoodDiaryEntry().foods
    @State var diaryWokrouts: [Workout] = WorkoutDiaryEntry().workouts
    
    var foodsByMeal: [Int: [Food]] {
        Dictionary(grouping: diaryFoods) { $0.meal.id }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Heading(text: "📒 Diary")
                    Spacer()
                    DatePicker(selection: $selectedDate, displayedComponents: .date) {
                        EmptyView()
                    }
                    
                    Button(action: {}, label: {
                        Image(systemName: "plus")
                            .font(.system(size: 25))
                    })
                    
                    .padding(.trailing)
                    .onChange(of: selectedDate) { newValue, oldValue in
                        if newValue != oldValue {
                            fetchFoodDiary()
                            fetchWorkoutDiary()
                        }
                    }
                }
            }
            .onAppear(perform: fetchFoodDiary) // Fetch food diary when the view appears
            .onAppear(perform: fetchWorkoutDiary) // Fetch food diary when the view appears

            if diaryFoods.isEmpty && diaryWokrouts.isEmpty {
                VStack {
                    Spacer()
                    Text("No diary entries for this day")
                    Spacer()
                }
            } else {
                VStack {
                    List {
                        ForEach(foodsByMeal.keys.sorted(), id: \.self) { mealId in
                            Section(header: Text(diaryFoods.first(where: { $0.meal.id ==  mealId })?.meal.name ?? "")) {
                                ForEach(foodsByMeal[mealId]!, id: \.id) { food in
                                    DiaryRow(foodName: food.name, foodWeightInG: 100.0, nutritionalInfo: food.nutritionalInfo)
                                        .onTapGesture {
                                            DispatchQueue.main.async {
                                                selectedFood = food
                                            }
                                        }
                                }
                            }
                        }
                        .sheet(item: $selectedFood) { food in
                            FoodDetailView(food: food)
                        }
                        
                        Section("Workout Diary") {
                                ForEach(diaryWokrouts, id: \.id) { workout in
                                    Text(workout.exercises[0].name)
                            }
                        }
                        // TODO: Remove this
                        .foregroundColor(.green)
                    }
                }
            }
        }
    }

    
    func fetchFoodDiary() {
        DiaryService().fetchFoodDiaryEntry(date: selectedDate) { result in
            switch result {
            case .success(let entry):
                diaryFoods = entry.foods
                print(entry)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchWorkoutDiary() {
        DiaryService().fetchWorkoutDiaryEntry(date: selectedDate) { result in
            switch result {
            case .success(let entry):
                diaryWokrouts = entry.workouts
                print(entry)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    #Preview {
        ContentView().environmentObject(UserViewModel())
    }
}
