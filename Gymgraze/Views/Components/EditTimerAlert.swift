//
//  SwiftUIView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 27/04/2024.
//

import SwiftUI

struct EditTimerAlert: View {
    @Binding var restTimerValue: String
    @State var exerciseTypeId: Int
    @ObservedObject var exercise: Exercise
    
    var body: some View {
        TextField("Seconds", text: $restTimerValue)
        Button("Update", action: {
            self.exercise.timer = Int(restTimerValue)
            UserService().updateTimer(timer: Int(restTimerValue)!, exerciseTypeId: exerciseTypeId) { result in
                switch result {
                case .success(let exerciseType):
                    print(exerciseType)
                case .failure(let error):
                    print(error)
                }
            }
        })
        Button("Cancel", role: .cancel, action: {})
    }
}

//#Preview {
//    EditTimerAlert()
//}
