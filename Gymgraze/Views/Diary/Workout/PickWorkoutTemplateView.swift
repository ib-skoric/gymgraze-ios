//
//  PickWorkoutTemplateView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 06/04/2024.
//

import SwiftUI

struct PickWorkoutTemplateView: View {
    @Environment(\.dismiss) var dismiss
        @Binding var date: Date
        @Binding var isAddWorkoutViewPresented: Bool

        var body: some View {
            // Your existing code...
            Button(action: {
                isAddWorkoutViewPresented.toggle()
                print("\(isAddWorkoutViewPresented)")
            }, label: {
                Text("Pick template")
            })
        }
    }

#Preview {
    PickWorkoutTemplateView(date: .constant(Date()), isAddWorkoutViewPresented: .constant(false))
}
