//
//  DiaryView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 18/02/2024.
//

import SwiftUI

struct DiaryView: View {
    var body: some View {
        NavigationStack {
            
            Heading(text: "📒 Your diary")
            
            List {
                Text("Hello World")
                Text("Hello World")
                Text("Hello World")
            }
        }
    }
}

#Preview {
    ContentView()
}
