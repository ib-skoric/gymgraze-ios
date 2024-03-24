//
//  AddToWokroutDiaryView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 22/03/2024.
//

import SwiftUI

struct AddWorkoutView: View {
    
    @State private var startedAt: Date = Date.now
    
    
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        return dateFormatter.string(from: date)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    Heading(text: "New workout")
                    Text("Started at: \(formatDate(date: startedAt))")
                        .fontWeight(.light)
                        .font(.subheadline)
                }
                
                Spacer()
                
                Button(action: {}) {
                    Text("Add exercise")
                }.buttonStyle(CTAButton())
                    .padding()
            }
        }
    }
}

#Preview {
    AddWorkoutView()
}
