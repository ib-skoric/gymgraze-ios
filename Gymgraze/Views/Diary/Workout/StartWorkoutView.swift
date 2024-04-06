//
//  StartWorkoutView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 06/04/2024.
//

import SwiftUI

struct StartWorkoutView: View {
    @State var date: Date = Date()
    @State var isAddWorkoutViewPresented: Bool = false
    @State var selectedTemplate: WorkoutTemplate?
    
    var body: some View {
        ZStack {
            if !isAddWorkoutViewPresented {
                PickWorkoutTemplateView(date: $date, isAddWorkoutViewPresented: $isAddWorkoutViewPresented, selectedTemplate: $selectedTemplate)
            } else {
                AddWorkoutView(date: $date, selectedTemplate: $selectedTemplate)
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
}

#Preview {
    StartWorkoutView()
}
