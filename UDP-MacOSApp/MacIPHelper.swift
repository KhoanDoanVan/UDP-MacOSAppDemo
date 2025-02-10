//
//  MacIPHelper.swift
//  UDP-MacOSApp
//
//  Created by Đoàn Văn Khoan on 10/2/25.
//

import Foundation
import Network

func getLocalIPAddress() -> String? {
    var address: String?
    let interfaces = ["en0", "en1"]  // en0 = Wi-Fi, en1 = Ethernet

    for interface in interfaces {
        var addrList: UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&addrList) == 0 {
            var ptr = addrList
            while ptr != nil {
                let flags = Int32(ptr!.pointee.ifa_flags)
                let addr = ptr!.pointee.ifa_addr.pointee
                if addr.sa_family == UInt8(AF_INET) && flags & (IFF_UP | IFF_RUNNING | IFF_LOOPBACK) == (IFF_UP | IFF_RUNNING) {
                    if let ifa_name = String(validatingUTF8: ptr!.pointee.ifa_name), ifa_name == interface {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(ptr!.pointee.ifa_addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count), nil, 0, NI_NUMERICHOST)
                        address = String(cString: hostname)
                    }
                }
                ptr = ptr!.pointee.ifa_next
            }
            freeifaddrs(addrList)
        }
    }
    return address
}
