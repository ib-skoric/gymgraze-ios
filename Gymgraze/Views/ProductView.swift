//
//  ProductView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 03/03/2024.
//

import SwiftUI

struct ProductView: View {
    
    @State var barcode: String
    
    var body: some View {
        Text(barcode)
    }
}

#Preview {
    ProductView(barcode: "4543435454534")
}
