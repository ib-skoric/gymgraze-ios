//
//  ProfileView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 18/02/2024.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var loginVM: LoginViewModel
    
    var body: some View {
        NavigationStack {
            Heading(text: "🧑 Profile")
            
            List {
                NavigationLink {
                    // TODO: Add a view here
                } label: {
                    HStack {
                        Image(systemName: "person")
                            .foregroundColor(.gray)
                        Text("Personal information")
                    }
                }
                
                NavigationLink {
                    // TODO: Add a view here
                } label: {
                    HStack {
                        Image(systemName: "target")
                            .foregroundColor(.gray)
                        Text("Goals")
                    }
                }
                
                NavigationLink {
                    // TODO: Add a view here
                } label: {
                    HStack {
                        Image(systemName: "heart.text.square.fill")
                            .foregroundColor(.gray)
                        Text("Apple Health data")
                    }
                }
                
                Button(action: { loginVM.logout() }, label: {
                        Text("Log out")
                    })
            }
        }
    }
}

#Preview {
    ProfileView()
}
