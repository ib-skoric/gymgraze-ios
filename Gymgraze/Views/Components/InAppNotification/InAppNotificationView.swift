//
//  InAppNotificationView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 03/05/2024.
//

import SwiftUI

struct InAppNotificationView: View {
    
    var style: InAppNotificationStyle
    var message: String
    var width: CGFloat = .infinity
    var onCanceled: (() -> Void)
    
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
              Image(systemName: style.icon)
                .foregroundColor(style.colour)
              Text(message)
                .font(Font.caption)
                .foregroundColor(.primary)
              
              Spacer(minLength: 10)
              
              Button {
                  onCanceled()
              } label: {
                Image(systemName: "xmark")
                  .foregroundColor(style.colour)
              }
            }
            .padding()
            .frame(minWidth: 0, maxWidth: width)
            .background(.thinMaterial)
            .cornerRadius(8)
            .overlay(
              RoundedRectangle(cornerRadius: 8)
                .opacity(0.6)
            )
            .padding(.horizontal, 16)
          }
}

//#Preview {
//    InAppNotificationView()
//}
