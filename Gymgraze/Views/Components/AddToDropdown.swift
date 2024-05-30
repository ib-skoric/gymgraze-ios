//
//  AddToDropdown.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 22/03/2024.
//

import SwiftUI

struct AddToDropdown: View {
    // state and env variables to handle view updates
    var type: String
    @Binding var date: Date
    @Binding var notification: InAppNotification?
    @EnvironmentObject var diaryVM: DiaryViewModel

    var body: some View {
        // show menu
        Menu {
            NavigationLink {
                AddToFoodDiaryView(date: $date)
            } label: {
                Label("Add food", systemImage: "fork.knife")
            }
            .accessibilityLabel("Add food button")
            NavigationLink {
                StartWorkoutView(date: date, notification: $notification)
            } label: {
                Label("Add workout", systemImage: "figure.run")
            }
            .accessibilityLabel("Add workout button")
            if diaryVM.diaryProgressEntry == nil {
                NavigationLink {
                    AddProgressLogView(date: date, notification: $notification)
                } label: {
                    Label("Add progress log", systemImage: "square.and.pencil")
                        .environmentObject(diaryVM)
                }
                .accessibilityLabel("Add progress log button")

            }
        } label: {
            // compute label based on button type
            if type == "menu" {
                Label("", systemImage: "plus")
                    .font(.system(size: 20))
                    .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.purple, .orange]), startPoint: .top, endPoint: .bottom))
            } else {
                Button(action: {}, label: {
                    Label("Add to diary", systemImage: "plus")
                }).buttonStyle(CTAButton())
                    .padding()
            }
        }
        .padding(.trailing)
    }
}
