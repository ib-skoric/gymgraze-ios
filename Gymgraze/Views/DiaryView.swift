import SwiftUI

struct DiaryView: View {
    
    @EnvironmentObject var userVM: UserViewModel
    @ObservedObject var diaryVM = DiaryViewModel()
    @State var diaryFoods: [Food] = FoodDiaryEntry().foods
    @State var selectedDate: Date = Date()
    @State private var selectedFood: Food?
    @State private var isDetailViewPresented: Bool = false
    
    var foodsByMeal: [String: [Food]] {
        Dictionary(grouping: diaryFoods) { $0.meal.name }
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
                    .padding(.trailing)
                }
            }
            
            List {
                ForEach(foodsByMeal.keys.sorted(), id: \.self) { mealName in
                    Section(header: Text(mealName)) {
                        ForEach(foodsByMeal[mealName]!, id: \.id) { food in
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
                
                Button(action: {
                    fetchFoodDiary()
                }, label: {
                    Text("Fetch Food Diary")})
            }
        }
    }
    
    func fetchFoodDiary() {
        FoodDiaryService().fetchFoodDiaryEntry() { result in
            switch result {
            case .success(let entry):
                diaryFoods = entry.foods
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
