//
//  UDP_MacOSAppApp.swift
//  UDP-MacOSApp
//
//  Created by Đoàn Văn Khoan on 10/2/25.
//

import SwiftUI

@main
struct UDP_MacOSAppApp: App {
    var body: some Scene {
        WindowGroup {
            if let ip = getLocalIPAddress() {
                ContentView(ipAddress: ip)
            } else {
                Text("Failed to get IP Address")
            }
        }
    }
}
