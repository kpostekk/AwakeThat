//
//  DeviceRow.swift
//  AwakeThat
//
//  Created by Krystian Postek on 07/08/2021.
//

import SwiftUI

struct DeviceRow: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @ObservedObject var device: DeviceWake
    
    var body: some View {
        HStack {
            if let imgName = device.icon {
                Image(systemName: imgName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal, 8.0)
                    .frame(width: 42)
                    .foregroundColor(.primary)
            }
            VStack(alignment: .leading, spacing: 4, content: {
                Text(device.alias ?? device.macAddr ?? "")
                    .modifier(DeviceTitle())
                Text(device.brAddr ?? "")
                    .modifier(DevicePropsText())
            })
        }
    }
}

struct DeviceRow_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                DeviceRow(device: testDevice()).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            }
            .listStyle(InsetGroupedListStyle())
        }
    }
    
    static func testDevice() -> DeviceWake {
        let context = PersistenceController.preview.container.viewContext
        let td = DeviceWake(context: context)
        td.alias = "AliasAlias"
        td.brAddr = "192.168.1.96"
        td.macAddr = "90:1B:0E:15:A7:19"
        td.icon = "pc"
        try? context.save()
        return td
    }
}
