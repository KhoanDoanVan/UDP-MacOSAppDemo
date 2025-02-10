//
//  ContentView.swift
//  UDP-MacOSApp
//
//  Created by Đoàn Văn Khoan on 10/2/25.
//

import SwiftUI

struct ContentView: View {
    let ipAddress: String

    var body: some View {
        TabView {
            QRCodeView(ipAddress: ipAddress)
                .tabItem {
                    Label("QR Code", systemImage: "qrcode")
                }

            GestureBoxView()
                .tabItem {
                    Label("Gesture Box", systemImage: "square.and.pencil")
                }
        }
        .frame(width: 400, height: 400)
    }
}
