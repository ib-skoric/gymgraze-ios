//
//  CreateTemplateView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 07/04/2024.
//

import SwiftUI

struct CreateWorkoutTemplateView: View {
    
    @State private var showAddExerciseView: Bool = false
    @StateObject var viewModel = AddWorkoutViewModel()
    @State private var isEditing: Bool = false
    
    var body: some View {
        HStack {
            Heading(text: "New template")
            
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
        
        VStack {
            InputField(data: $viewModel.templateName, title: "Template name")
            
            if viewModel.workoutExercies.isEmpty {
                Spacer()
                Text("No exercises added")
                    .font(.title)
                    .foregroundColor(.gray)
                Spacer()
            } else {
                List {
                    ForEach(viewModel.workoutExercies.indices, id: \.self) { index in
                        Text(viewModel.workoutExercies[index].name)
                    }
                    .onMove { source, destination in
                        DispatchQueue.main.async {
                            viewModel.workoutExercies.move(fromOffsets: source, toOffset: destination)
                        }
                    }
                }
                .toolbar {
                    EditButton()
                }
                
                Spacer()
                
                Button(action: {
                    viewModel.saveTemplate() { result in
                        switch result {
                        case .success(_):
                            print("Template saved")
                        case .failure(let error):
                            print("Error saving template: \(error)")
                        }
                    }
                }, label: {
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        Text("Save template")
                    }
                })
                .buttonStyle(CTAButton())
                .padding()
            }
        }

    }
}

#Preview {
    CreateWorkoutTemplateView()
}
