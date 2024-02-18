//
//  Card.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 18/02/2024.
//

import SwiftUI

struct StatCard: View {
    
    var type: String
    
    var colour: Color {
        switch type {
        case "calories":
            return .red
        case "workouts":
            return .green
        case "steps":
            return .blue
        default:
            return .gray
        }
    }
    
    var text: String {
        switch type {
        case "calories":
            return "Calories consumed today"
        case "workouts":
            return "Workout minutes done today"
        case "steps":
            return "Steps taken so far"
        default:
            return "No data available"
        }
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(colour)
                .shadow(radius: 10)
            HStack {
                switch type {
                case "calories":
                    Image(systemName: "fork.knife.circle.fill")
                        .font(.custom("Main Icon", size: 65.0))
                
                case "workouts":
                    Image(systemName: "bolt.fill")
                        .font(.custom("Main Icon", size: 65.0))
                    
                case "steps":
                    Image(systemName: "shoe.2.fill")
                        .font(.custom("Main Icon", size: 65.0))
                    
                default:
                    Image(systemName: "info.circle.fill")
                        .font(.custom("Main Icon", size: 65.0))
                }
                VStack {
                    Text(text)
                        .fontWeight(.light)
                    Text("500/1750")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .multilineTextAlignment(.center)
            .padding()
        }.padding()
    }
}

#Preview {
    StatCard(type: "calories").frame(height: 200)
}
