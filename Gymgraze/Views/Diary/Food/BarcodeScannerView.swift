//
//  BarcodeScannerView.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 03/03/2024.
//

import SwiftUI
import VisionKit


struct BarcodeScannerView: View {
    
    // state and env variables to handle view updates
    @State var isShowingScanner = true
    @State private var scannedText = ""
    @State var showProductView = false
    @State private var id = 0
    @State private var notification: InAppNotification? = nil
    
    var body: some View {
        // check that the device supports data scanner
        if DataScannerViewController.isSupported && DataScannerViewController.isAvailable {
            NavigationStack {
                ZStack(alignment: .bottom) {
                    // use the DataScannerRepresentable to scan for barcode
                    DataScannerRepresentable(
                        shouldStartScanning: $isShowingScanner,
                        showProductView: $showProductView,
                        scannedText: $scannedText,
                        dataToScanFor: [.barcode(symbologies: [.ean13])]
                    )
                    .id(id)
                    // when scanned, pop up the sheet
                    .sheet(isPresented: $showProductView) {
                        ProductView(barcode: scannedText, selectedDate: Date(), notification: $notification)
                    }
                }
                // when the sheet is dismissed, reset the scanned text and show the scanner again
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
        // if device does not support this feature then show message. 
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
