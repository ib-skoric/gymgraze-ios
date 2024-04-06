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

    var body: some View {
        ZStack {
            if !isAddWorkoutViewPresented {
                PickWorkoutTemplateView(date: $date, isAddWorkoutViewPresented: $isAddWorkoutViewPresented)
            } else {
                AddWorkoutView(date: $date)
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
}

#Preview {
    StartWorkoutView()
}
