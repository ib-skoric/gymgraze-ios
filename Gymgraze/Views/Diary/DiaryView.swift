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
                            
                            Button(action: {
                                isAddViewPresented = true
                            }, label: {
                                Image(systemName: "plus")
                                    .font(.system(size: 25))
                            })
                            .padding(.trailing)
                            
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
                                Button(action: {
                                    isAddViewPresented = true
                                }, label: {
                                    Text("Add entry")
                                })
                                .padding()
                                .buttonStyle(CTAButton())
                            }
                            .padding()
                            Spacer()
                        } else {
                            List {
                                if !diaryVM.diaryFoods.isEmpty {
                                    ForEach(foodsByMeal.keys.sorted(), id: \.self) { mealId in
                                        Section(header: Text(diaryVM.diaryFoods.first(where: { $0.meal.id ==  mealId })?.meal.name ?? "")) {
                                            ForEach(foodsByMeal[mealId]!, id: \.id) { food in
                                                FoodDiaryRow(food: food, nutritionalInfo: food.nutritionalInfo)
                                                    .onTapGesture {
                                                        selectedFood = food
                                                    }
                                            }
                                        }
                                    }
                                    .sheet(item: $selectedFood) { food in
                                        FoodDetailView(food: food)
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
                    .background(
                        NavigationLink(
                            destination: AddToDiaryView(),
                            isActive: $isAddViewPresented,
                            label: {
                                EmptyView()
                            })
                    )
                }
            }
        }
    }
    
    #Preview {
        ContentView().environmentObject(UserViewModel())
    }
}
