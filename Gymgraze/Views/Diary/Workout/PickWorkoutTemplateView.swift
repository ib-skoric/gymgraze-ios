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
    @ObservedObject var viewModel = WorkoutTemplatesViewModel()
    @Binding var selectedTemplate: WorkoutTemplate?
    
    var body: some View {
        VStack {
            HStack {
                Heading(text: "Pick workout template")
                
                Spacer()
                
                Button(action: {
                    
                }, label: {
                    Label("", systemImage: "plus")
                        .font(.system(size: 25))
                        .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.purple, .orange]), startPoint: .top, endPoint: .bottom))
                })
                .padding(.trailing)
            }
            
            Spacer()
            
            List(viewModel.workoutTemplates) { template in
                WorkoutTemplateRow(workoutTemplate: template)
                    .onTapGesture {
                        selectedTemplate = template
                        isAddWorkoutViewPresented.toggle()
                    }
            }
        }.onAppear {
            viewModel.fetchWorkoutTemplates()
        }
    }
}

//#Preview {
//    PickWorkoutTemplateView(date: .constant(Date()), isAddWorkoutViewPresented: .constant(false))
//}
