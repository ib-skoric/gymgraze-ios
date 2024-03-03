//
//  BarcodeScannerView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 03/03/2024.
//

import SwiftUI
import VisionKit


struct BarcodeScannerView: View {
    
    @State var isShowingScanner = true
    @State private var scannedText = ""
    
    var body: some View {
        if DataScannerViewController.isSupported && DataScannerViewController.isAvailable {
            ZStack(alignment: .bottom) {
                DataScannerRepresentable(
                    shouldStartScanning: $isShowingScanner,
                    scannedText: $scannedText,
                    dataToScanFor: [.barcode(symbologies: [.ean13])]
                )
                
                Text(scannedText)
                    .padding()
                    .background(Color.white)
                    .foregroundColor(.black)
            }
        } else if !DataScannerViewController.isSupported {
            Text("It looks like this device doesn't support the DataScannerViewController")
        } else {
            Text("It appears your camera may not be available")
        }
    }
}

#Preview {
    BarcodeScannerView()
}
