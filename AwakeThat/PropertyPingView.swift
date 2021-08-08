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
    
    var body: some View {
        PropertyView(key: "Device ping", val: $duration)
            .onAppear(perform: ping)
            .onDisappear() {
                pinger?.stopPinging()
            }
    }
    
    func ping() {
        if let ipAddr = targetAddr {
            pinger = try! SwiftyPing(ipv4Address: ipAddr, config: .init(interval: 1, with: 2), queue: .global(qos: .userInitiated))
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
