//
//  LoginButton.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 25/01/2024.
//

import SwiftUI

struct LoginButtonCTA: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(.primary)
                .cornerRadius(10)
                .padding([.leading, .trailing])
                // give it rounded corners and a gradient border
                .background(
                    // check if button is disabled
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(LinearGradient(gradient: Gradient(colors: [.purple, .orange]), startPoint: .top, endPoint: .bottom), lineWidth: 1)
                )
        }
}
