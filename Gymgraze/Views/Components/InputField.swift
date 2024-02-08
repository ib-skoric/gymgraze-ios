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
                
                // add condition to make the input field secure for passwords
                if title == "Password" {
                    SecureField("", text: $data)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                } else if (title == "Email") {
                    TextField("", text: $data)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
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
    LoginInput(data: .constant(""), title: "Email")
}
