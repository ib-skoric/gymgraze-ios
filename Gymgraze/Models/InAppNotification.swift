//
//  File.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 03/05/2024.
//

import Foundation

struct InAppNotification: Equatable {
    var style: InAppNotificationStyle
    var message: String
    var duration: Double = 4
    var width: Double = .infinity
}
