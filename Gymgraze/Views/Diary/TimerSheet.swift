//
//  TimerSheet.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 31/03/2024.
//

import SwiftUI

struct TimerSheet: View {
    @Binding var timerValue: Int
    @State private var offset = CGSize.zero
    
    var body: some View {
        Text("This is the timer view")
    }
}

//#Preview {
//    TimerSheet()
//}
