//
//  UDPReceiver.swift
//  UDP-MacOSApp
//
//  Created by Đoàn Văn Khoan on 10/2/25.
//

import Network

class UDPReceiver {
    private var listener: NWListener?
    
    func start(onReceive: @escaping (CGFloat, CGFloat) -> Void) {
        do {
            let listener = try NWListener(using: .udp, on: 8080)
            self.listener = listener
            
            listener.newConnectionHandler = { [weak self] connection in
                connection.start(queue: .global())
                self?.receive(on: connection, onReceive: onReceive)
            }
            
            listener.stateUpdateHandler = { state in
                switch state {
                case .ready:
                    print("UDP Server is ready and listening on port 8080")
                case .failed(let error):
                    print("UDP Server failed: \(error.localizedDescription)")
                default:
                    break
                }
            }
            
            listener.start(queue: .global())
        } catch {
            print("UDP Server failed to start: \(error.localizedDescription)")
        }
    }
    
    private func receive(on connection: NWConnection, onReceive: @escaping (CGFloat, CGFloat) -> Void) {
        connection.receiveMessage { [weak self] data, _, _, error in
            if let error = error {
                print("Error receiving UDP message: \(error.localizedDescription)")
                self?.restartListener()
                return
            }
            
            if let data = data, let message = String(data: data, encoding: .utf8) {
                if message == "READY" {
                    print("Handshake received! macOS is ready to receive gestures.")
                } else {
                    let values = message.split(separator: ",").compactMap { Double($0) }
                    if values.count == 2 {
                        onReceive(CGFloat(values[0]), CGFloat(values[1]))
                    } else {
                        print("Invalid data format received: \(message)")
                    }
                }
            }
            
            self?.receive(on: connection, onReceive: onReceive)
        }
    }
    
    private func restartListener() {
        print("Restarting UDP Listener...")
        listener?.cancel()
        start { _, _ in }
    }
}
