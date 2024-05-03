//
//  ToastStyle.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 03/05/2024.
//

import Foundation
import SwiftUI

enum InAppNotificationStyle {
    case error
    case success
}

extension InAppNotificationStyle {
    var colour : Color {
        switch self {
        case .error:
            return Color.red
        case .success:
            return Color.green
        }
    }
    
    var icon: String {
        switch self {
        case .error:
            return "xmark.octagon.fill"
        case .success:
            return "checkmark.circle.fill"
        }
    }
}



