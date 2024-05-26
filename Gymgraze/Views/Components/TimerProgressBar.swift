//
//  TimerProgressBar.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 22/04/2024.
//

import Foundation
import SwiftUI

// make the progressview style
struct GradientProgressViewStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        GeometryReader { geometry in
            let width = geometry.size.width * CGFloat(configuration.fractionCompleted ?? 0)
            ZStack(alignment: .leading) {
                Capsule()
                    .foregroundColor(Color.gray.opacity(0.2))
                Capsule()
                    .fill(LinearGradient(gradient: Gradient(colors: [.purple, .orange]), startPoint: .leading, endPoint: .trailing))
                    .frame(width: width)
            }
        }
    }
}
