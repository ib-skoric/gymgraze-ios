//
//  PickWorkoutTemplateView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 06/04/2024.
//

import SwiftUI

struct PickWorkoutTemplateView: View {
    @Binding var date: Date
    @Binding var isAddWorkoutViewPresented: Bool
    @State var isCreateTemplateViewPresented: Bool = false
    @ObservedObject var viewModel = WorkoutTemplatesViewModel()
    @Binding var selectedTemplate: WorkoutTemplate?
    
    var body: some View {
        VStack {
            HStack {
                Heading(text: "Pick workout template")
                
                Spacer()
                
                Button(action: {
                    isCreateTemplateViewPresented.toggle()
                }, label: {
                    Label("", systemImage: "plus")
                        .font(.system(size: 25))
                        .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.purple, .orange]), startPoint: .top, endPoint: .bottom))
                })
                .padding(.trailing)
                .background {
                    NavigationLink(destination: CreateWorkoutTemplateView(), isActive: $isCreateTemplateViewPresented) {}
                }
            }
            
            Spacer()
            
            List {
                ForEach(viewModel.workoutTemplates, id: \.self) { template in
                    WorkoutTemplateRow(workoutTemplate: template)
                        .onTapGesture {
                            selectedTemplate = template
                            isAddWorkoutViewPresented.toggle()
                        }
                }
                .onDelete(perform: delete)
                
                Button(action: {
                        isAddWorkoutViewPresented.toggle()
                    }, label: {
                        Text("**Empty workout**")
                            .foregroundColor(.orange)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                    })
            }
        }.onAppear {
            viewModel.fetchWorkoutTemplates()
        }
    }
    
    func delete(at offsets: IndexSet) {
        viewModel.deleteWorkoutTemplate(id: viewModel.workoutTemplates[offsets.first!].id)
        viewModel.workoutTemplates.remove(atOffsets: offsets)
    }
}
