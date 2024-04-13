//
//  AddProgressLogView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 13/04/2024.
//

import SwiftUI

struct AddProgressLogView: View {
    @State var date: Date = Date()
    
    var body: some View {
        Text("Today's date is: \(date)")
    }
}

#Preview {
    AddProgressLogView()
}
