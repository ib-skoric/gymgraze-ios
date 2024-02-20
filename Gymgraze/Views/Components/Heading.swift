//
//  Heading.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 20/02/2024.
//

import SwiftUI

struct Heading: View {
    
    var text: String
    var icon: String?
    
    var body: some View {
        HStack {
            Text("\(text)")
                .font(.title)
                .fontWeight(.bold)
            Spacer()
            
            if (icon != nil) {
                Image(systemName: "\(icon ?? "questionmark")")
                    .font(.title3)
                    .foregroundColor(.gray)
            }
        }
        .padding()
    }
}

#Preview {
    Heading(text: "Hello, Ivan 👋", icon: "gear")
}
