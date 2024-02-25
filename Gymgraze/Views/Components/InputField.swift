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
            
            // switch based on title
            switch title {
            case "Password":
                SecureField("", text: $data)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                
            case "Email":
                TextField("", text: $data)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                
            case "Age", "Weight", "Height":
                TextField("", text: $data)
                    .keyboardType(.numberPad)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
            default:
                TextField("", text: $data)
                    .padding()
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
