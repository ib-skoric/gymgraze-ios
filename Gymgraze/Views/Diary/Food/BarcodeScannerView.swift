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
    @State var showProductView = false
    @State private var id = 0
    @State private var notification: InAppNotification? = nil
    
    var body: some View {
        if DataScannerViewController.isSupported && DataScannerViewController.isAvailable {
            NavigationStack {
                ZStack(alignment: .bottom) {
                    DataScannerRepresentable(
                        shouldStartScanning: $isShowingScanner,
                        showProductView: $showProductView,
                        scannedText: $scannedText,
                        dataToScanFor: [.barcode(symbologies: [.ean13])]
                    )
                    .id(id)
                    .sheet(isPresented: $showProductView) {
                        ProductView(barcode: scannedText, selectedDate: Date(), notification: $notification)
                    }
                }
                .onChange(of: showProductView) { isShowing in
                    if !isShowing {
                        scannedText = ""
                        isShowingScanner = false
                        DispatchQueue.main.async {
                            isShowingScanner = true
                            id += 1
                        }
                    }
                }
            }
            .inAppNotificationView(notification: $notification)
        }
            
        else if !DataScannerViewController.isSupported {
            Text("It looks like you might be using a similator. This must be tried on a real device")
        } else {
            Text("It appears your camera may not be available")
        }
    }
}

#Preview {
    BarcodeScannerView()
}
