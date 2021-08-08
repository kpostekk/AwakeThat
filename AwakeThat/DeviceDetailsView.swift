//
//  DeviceDetailsView.swift
//  AwakeThat
//
//  Created by Krystian Postek on 07/08/2021.
//

import SwiftUI

struct DeviceDetailsView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @ObservedObject var device: DeviceWake

    var body: some View {
        Form {
            Section(header: Text("Device Properties")) {
                if device.alias != nil {
                    PropertyView(key: "MAC address", val: device.macAddr!)
                }
                PropertyView(key: "Broadcast address", val: device.brAddr!)
            }

            Section(header: Label("Actions", systemImage: "bolt")) {
                Button(action: { device.awakeDevice() }, label: {
                    Label("Send magic packet", systemImage: "power")
                })
            }
        }
        .navigationTitle(device.alias != nil ? device.alias! : device.macAddr!)
    }
}

struct PropertyView: View {
    @State var key: String
    @State var val: String

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
        td.alias = "AliasAlias"
        td.brAddr = "192.168.1.96"
        td.macAddr = "90:1B:0E:15:A7:19"
        try? context.save()
        return td
    }
}
