//
//  QRCodeGenerator.swift
//  UDP-MacOSApp
//
//  Created by Đoàn Văn Khoan on 10/2/25.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct QRCodeView: View {
    let ipAddress: String
    
    var body: some View {
        VStack {
            Text("Scan this QR on iOS")
                .font(.title)
                .padding()
            
            if let qrImage = generateQRCode(from: ipAddress) {
                Image(nsImage: qrImage)
                    .resizable()
                    .interpolation(.none)
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            } else {
                Text("Failed to generate QR")
            }
        }
    }
    
    func generateQRCode(from string: String) -> NSImage? {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        filter.message = Data(string.utf8)

        if let outputImage = filter.outputImage,
           let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            return NSImage(cgImage: cgImage, size: NSSize(width: 200, height: 200))
        }
        return nil
    }
}
