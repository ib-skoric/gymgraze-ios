//
//  StartWorkoutView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 06/04/2024.
//

import SwiftUI

struct StartWorkoutView: View {
    
    // state and env variables to handle view updates
    @State var date: Date = Date()
    @State var isAddWorkoutViewPresented: Bool = false
    @State var selectedTemplate: WorkoutTemplate?
    @Binding var notification: InAppNotification?
    @EnvironmentObject var diaryVM: DiaryViewModel
    
    var body: some View {
        ZStack {
            // check if add workout view is presented
            if !isAddWorkoutViewPresented {
                PickWorkoutTemplateView(date: $date, isAddWorkoutViewPresented: $isAddWorkoutViewPresented, selectedTemplate: $selectedTemplate)
            } else {
                AddWorkoutView(date: $date, selectedTemplate: $selectedTemplate, notification: $notification)
            }
        }
    }
}
