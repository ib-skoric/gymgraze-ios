//
//  SplashScreen.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 27/04/2024.
//

import SwiftUI

struct SplashScreen: View {
    // state variable
    @State private var scale: CGFloat = 0.7
    
    var body: some View {
        Spacer()
        VStack {
            VStack {
                // show logo
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250, height: 250)
                    .scaleEffect(scale)
                    .padding(.bottom)
            }.scaleEffect(0.7)
            
            // show text and progress view
            Text("Loading your data...")
            ProgressView()
        }
    
        Spacer()
    }
}

#Preview {
    SplashScreen()
}
