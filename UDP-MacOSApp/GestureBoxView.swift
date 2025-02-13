//
//  GestureBoxView.swift
//  UDP-MacOSApp
//
//  Created by Đoàn Văn Khoan on 10/2/25.
//

import SwiftUI

struct GestureBoxView: View {
    @State private var boxPosition: CGPoint = CGPoint(x: 200, y: 200)
    let udpServer = UDPReceiver()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.gray.opacity(0.2).edgesIgnoringSafeArea(.all)
                
                Rectangle()
                    .fill(Color.red.opacity(0.5))
                    .frame(width: 50, height: 50)
                    .position(boxPosition)
                    .animation(.easeInOut(duration: 0.1), value: boxPosition)
            }
            .onAppear {
                udpServer.start { x, y in
                    DispatchQueue.main.async {
                        if (0...1).contains(x), (0...1).contains(y) {
                            boxPosition = CGPoint(x: x * geometry.size.width, y: y * geometry.size.height)
                        } else {
                            print("Received out-of-bounds coordinates: (x: \(x), y: \(y))")
                        }
                    }
                }
            }
        }
    }
}
