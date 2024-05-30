//
//  LoginInput.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 25/01/2024.
//

import SwiftUI

struct InputField: View {
    
    // binding to store the data
    @Binding var data: String
    // the title to be displayed above the input field
    var title: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
                .foregroundStyle(.gray)
                .padding(4)
                .frame(maxWidth: .infinity, alignment: .leading)
                .offset(y: 10)
                .accessibilityLabel("\(title) input field")
            
            // switch based on title
            switch title {
            case "Password", "Your new password", "Confirm your new password":
                SecureField("", text: $data)
                    .padding()
                    .accessibilityLabel("\(title) input field")
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                
            case "Email":
                TextField("", text: $data)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .accessibilityLabel("\(title) input field")
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                
            case "Age", "Weight", "Height", "Steps", "Exercise", "Calories (kcal)", "👟 Target step count per day", "🏋️‍♂️ Target exercise daily (in minutes)", "🍏 Calories to consume per day (kcal)", "Weight (kg)", "Body fat percentage (%)", "Arm measurement (cm)", "Waist measurement (cm)", "Chest measurement (cm)":
                TextField("", text: $data)
                    .keyboardType(.decimalPad)
                    .padding()
                    .accessibilityLabel("\(title) input field")
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
            default:
                TextField("", text: $data)
                    .padding()
                    .accessibilityLabel("\(title) input field")
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
            }
            
        }.padding([.leading, .trailing])
    }
}

#Preview {
    InputField(data: .constant(""), title: "Email")
}
