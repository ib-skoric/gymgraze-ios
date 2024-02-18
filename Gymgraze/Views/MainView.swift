//
//  MainView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 18/02/2024.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var userVM: UserViewModel
    
    var body: some View {
                HStack {
                    Text("Welcome, Ivan 👋")
                        .font(.title)
                        .fontWeight(.bold)
                    Spacer()
                    Button(action: {}, label: {
                        Image(systemName: "gear")
                            .font(.title)
                            .foregroundColor(.gray)
                    })
                }
                .padding()
        Spacer()
    }
}

#Preview {
    MainView()
}
