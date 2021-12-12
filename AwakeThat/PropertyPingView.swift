//
//  PropertyPingView.swift
//  AwakeThat
//
//  Created by Krystian Postek on 08/08/2021.
//

import SwiftUI
import SwiftyPing

struct PropertyPingView: View {
    @State var targetAddr: String?
    @State var duration: String = "Offline"
    @State var pinger: SwiftyPing?
    
    @AppStorage("ping.interval") private var pingInterval: String = "1"
    @AppStorage("ping.timeout") private var pingTimeout: String = "4"
    
    var body: some View {
        PropertyView(key: "Device ping", val: $duration)
            .onAppear(perform: ping)
            .onDisappear() {
                pinger?.stopPinging()
            }
    }
    
    func ping() {
        if let ipAddr = targetAddr {
            pinger = try! SwiftyPing(ipv4Address: ipAddr, config: .init(interval: Double(pingInterval)!, with: Double(pingTimeout)!), queue: .global(qos: .userInitiated))
            pinger!.observer = {
                if $0.error == nil {
                    duration = String(format: "%.3fms", $0.duration * 1000)
                } else {
                    duration = "Offline"
                }
            }
            try? pinger!.startPinging()
        } else {
            duration = "Offline"
        }
    }
}

struct PropertyPingView_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            PropertyPingView(targetAddr: "192.168.1.91")
        }
    }
}
