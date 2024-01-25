//
//  LoginView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 14/12/2023.
//

import SwiftUI

struct LoginView: View {
    
    @State var email: String = ""
    @State var password: String = ""
    
    var body: some View {
        LoginInput(data: $email, title: "Email")
        LoginInput(data: $password, title: "Password")
    }
}

#Preview {
    LoginView()
}
