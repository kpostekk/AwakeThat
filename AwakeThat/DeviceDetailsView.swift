//
//  DeviceDetailsView.swift
//  AwakeThat
//
//  Created by Krystian Postek on 07/08/2021.
//

import AlertToast
import SwiftUI

struct DeviceDetailsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @AppStorage("ping.enable") private var pingEnable: Bool = true

    @ObservedObject var device: DeviceWake
    @State private var showingToast = false
    @State private var lockButton = false
    @State private var launching = false {
        didSet {
            if launching { // Wait 3 seconds and return to previous state (false)
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    launching.toggle()
                }
            }
        }
    }
    
    var body: some View {
        Form {
            Section() {
                Button(action: awakeRequest) {
                    HStack {
                        Spacer()
                        Image(systemName: "bolt")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.all, 32)
                            .foregroundColor(.green)
                            .rotationEffect(.degrees(launching ? 390 : 0))
                            .animation(.easeInOut(duration: 0.4), value: launching)
                        Text(launching ? "Launching..." : "Launch")
                            .animation(.easeInOut(duration: 0.4), value: launching)
                        Spacer()
                    }
                }.frame(height: 120).disabled(launching)
            }
            Section(header: Text("Device Properties")) {
                if device.alias != nil {
                    PropertyView(key: "MAC address", val: .constant(device.macAddr!))
                }
                PropertyView(key: "Broadcast address", val: .constant(device.brAddr!))
                if pingEnable {
                    PropertyPingView(targetAddr: device.brAddr!)
                }
            }
        }.navigationTitle(device.alias != nil ? device.alias! : device.macAddr!)
            .navigationBarTitleDisplayMode(.inline)
    }
    
    private func awakeRequest() {
        launching.toggle()
        device.awakeDevice()
    }
}

struct PropertyView: View {
    @State var key: String
    @Binding var val: String

    var body: some View {
        HStack {
            Text(key)
            Spacer()
            Text(val)
                .font(.system(.body, design: .monospaced))
        }
    }
}

struct DeviceDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DeviceDetailsView(device: testDevice()).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }

    static func testDevice() -> DeviceWake {
        let context = PersistenceController.preview.container.viewContext
        let td = DeviceWake(context: context)
        td.alias = "Workstation"
        td.brAddr = "192.168.1.96"
        td.macAddr = "90:1B:0E:15:A7:19"
        td.icon = SelectableIcon.iconsNames[2]
        try? context.save()
        return td
    }
}
