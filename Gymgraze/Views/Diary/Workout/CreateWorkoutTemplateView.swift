//
//  CreateTemplateView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 07/04/2024.
//

import SwiftUI

struct CreateWorkoutTemplateView: View {
    
    // state and env variables to handle view updates
    @State private var showAddExerciseView: Bool = false
    @StateObject var viewModel = AddWorkoutViewModel()
    @State private var isEditing: Bool = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        viewHeading
        
        VStack {
            InputField(data: $viewModel.templateName, title: "Template name")
                .accessibilityLabel("Template name input field")
            
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
                    handleSaveTemplate()
                }, label: {
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        Text("Save template")
                    }
                })
                .buttonStyle(CTAButton())
                .padding()
                .accessibilityLabel("Save template button")
            }
        }
    }
    
    func handleSaveTemplate() {
        viewModel.saveTemplate() { result in
            switch result {
            case .success(_):
                print("Template saved")
            case .failure(let error):
                print("Error saving template: \(error)")
            }
        }
        dismiss()
    }
    
    var viewHeading: some View {
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
    }
}

#Preview {
    CreateWorkoutTemplateView()
}
