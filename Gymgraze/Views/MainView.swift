//
//  MainView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 18/02/2024.
//

import SwiftUI

struct MainView: View {
    
    @StateObject var loginVM = LoginViewModel()
    @StateObject var userVM = UserViewModel()
    
    var body: some View {
        Text("Hello World this is the Main view")
    }
}

#Preview {
    MainView()
}
