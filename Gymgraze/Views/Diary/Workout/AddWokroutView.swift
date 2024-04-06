//
//  AddToWokroutDiaryView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 22/03/2024.
//

import SwiftUI

struct AddWorkoutView: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var diaryVM: DiaryViewModel
    @State private var startedAt: Date = Date.now
    @State private var repWeight: String = ""
    @State private var repCount: String = ""
    @State private var showAddExerciseView: Bool = false
    @State private var isWorkoutFinished: Bool = false
    @Binding var date: Date
    @Binding var selectedTemplate: WorkoutTemplate?
    @ObservedObject var viewModel = AddWorkoutViewModel()

    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        return dateFormatter.string(from: date)
    }
    
    func handleTemplate() {
        if let template = selectedTemplate {
            
            var exercises: [Exercise] = []
            var exerciseSets: [Exercise.ExerciseSet] = []
            
            // loop over template exercises and create new exercises
            for templateExercise in template.templateExercises {
                let exercise = Exercise()
                exercise.id = Int.random(in: 1...999999999)
                exercise.name = templateExercise.name
                exercise.exerciseTypeId = templateExercise.exerciseTypeId
                exercise.exerciseSets = exerciseSets
                // loop over historical set rep data and create new set rep data
                for historicalSetRepData in templateExercise.historicalSetRepData {
                    let setRepData = Exercise.ExerciseSet()
                    setRepData.weight = Double(historicalSetRepData.weight)
                    setRepData.reps = historicalSetRepData.reps
                    exerciseSets.append(setRepData)
                }
                
                exercise.exerciseSets = exerciseSets
                exercises.append(exercise)
            }
            
            viewModel.workoutExercies = exercises
            print("View model exercises: \(viewModel.workoutExercies)")
        }
    }

    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Heading(text: "New workout")
                    
                    Spacer()
                    
                    Button(action: {
                        showAddExerciseView = true
                    }, label: {
                        Label("", systemImage: "plus")
                            .font(.system(size: 25))
                            .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.purple, .orange]), startPoint: .top, endPoint: .bottom))
                    })
                    .padding(.trailing)
                    .sheet(isPresented: $showAddExerciseView) {
                        AddExerciseView(viewModel: viewModel)
                    }
                }
                
                Text("Started at: \(formatDate(date: startedAt))")
                    .fontWeight(.light)
                    .font(.subheadline)
                
                ScrollView {
                    ForEach(viewModel.workoutExercies) { exercise in
                        ExerciseCard(exercise: exercise, viewModel: viewModel)
                    }
                
                }
                .padding()
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                .onAppear() {
                    handleTemplate()
                }
                
                Spacer()
                
                Button(action: {
                        viewModel.date = date
                        viewModel.saveWorkout() { result in
                            switch result {
                            case .success(_):
                                DispatchQueue.main.async {
                                    print("successfully saved workout")
                                    self.isWorkoutFinished = true
                                    viewModel.reset()
                                    self.dismiss()
                                }
                            case .failure(let error):
                                print(error)
                            }
                        }
                }) {
                    Text("Finish workout")
                }
                    .buttonStyle(CTAButton())
                    .padding()

            }
        }
    }
}

//#Preview {
//    AddWorkoutView()
//}
