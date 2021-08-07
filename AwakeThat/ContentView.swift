//
//  ContentView.swift
//  AwakeThat
//
//  Created by Krystian Postek on 07/08/2021.
//

import Awake
import CoreData
import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var showingSheet = false
    @State private var editingDevice: DeviceWake?
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    @FetchRequest(sortDescriptors: [
        NSSortDescriptor(keyPath: \DeviceWake.alias, ascending: true)
    ], animation: .default)
    private var devices: FetchedResults<DeviceWake>

    var body: some View {
        NavigationView {
            List(devices) { device in
                HStack {
                    VStack(alignment: .leading, spacing: 4, content: {
                        Text(device.alias ?? device.macAddr!)
                            .modifier(DeviceTitle())
                        Text(device.brAddr!)
                            .modifier(DevicePropsText())
                    })
                    // Spacer()
                    /* Button(action: {}) {
                         Image(systemName: "power")
                             .font(.system(size: 32, weight: .ultraLight))
                     } */
                }
                .contextMenu(ContextMenu(menuItems: {
                    Button(action: { awakeDevice(device) }) {
                        Label("Send magic packet", systemImage: "power")
                    }
                    Button(action: { showEditSheet(device) }) {
                        Label("Edit", systemImage: "pencil")
                    }
                }))
            }
            .navigationTitle("Devices")
            .navigationBarItems(trailing: Button(action: showSheet) {
                Label("Add", systemImage: "plus")
            }
            .sheet(isPresented: $showingSheet) {
                FormSheet(editDevice: $editingDevice)
            }
            )
        }
    }
    
    private func showEditSheet(_ device: DeviceWake) {
        editingDevice = device
        showingSheet.toggle()
    }
    
    private func showSheet() {
        showingSheet.toggle()
    }

    private func deleteDevice(_ device: DeviceWake) {
        withAnimation {
            viewContext.delete(device)
            try? viewContext.save()
        }
    }

    private func awakeDevice(_ device: DeviceWake) {
        let awDevice = Awake.Device(MAC: device.macAddr!, BroadcastAddr: device.brAddr!, Port: UInt16(truncating: device.port!))
        _ = Awake.target(device: awDevice)
    }
}

struct DeviceTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 26, weight: .medium, design: .rounded))
    }
}

struct DevicePropsText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 16, weight: .regular, design: .monospaced))
    }
}

struct FormSheet: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode
    
    @Binding var editDevice: DeviceWake?
    @State var macAddr: String = ""
    @State var brAddr: String = ""
    @State var alias: String = ""
    @AppStorage("default-icon") var icon: Int = 0

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Device Properties")) {
                    TextField("MAC address", text: $macAddr)
                    TextField("Broadcasr address", text: $brAddr)
                        .keyboardType(.numberPad)
                    TextField("Alias", text: $alias)
                    Picker("Icon", selection: $icon) {
                        Label("PC", systemImage: "pc").tag(0)
                        Label("iMac", systemImage: "desktopcomputer").tag(1)
                        Label("Mac Pro trashbin", systemImage: "macpro.gen2").tag(2)
                        Label("Mac Pro cheese", systemImage: "macpro.gen3").tag(3)
                        Label("Server", systemImage: "xserve").tag(4)
                    }
                }
                Section {
                    Button(action: addDevice) {
                        Label("Save", systemImage: "square.and.arrow.down.on.square.fill")
                    }
                    if (editDevice != nil) {
                        Button(action: delDevice) {
                            Label("Delete", systemImage: "trash")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .navigationTitle(editDevice != nil ? "Edit device" : "Add device")
            .navigationBarItems(trailing: Button(action: { presentationMode.wrappedValue.dismiss() }) {
                Text("Hide")
            })
        }
        .onAppear() {
            if let edDev = editDevice {
                macAddr = edDev.macAddr!
                brAddr = edDev.brAddr!
                alias = edDev.alias ?? ""
            }
        }
    }

    private func addDevice() {
        let newDevice = (editDevice == nil) ? DeviceWake(context: viewContext) : editDevice!
        newDevice.macAddr = macAddr
        newDevice.brAddr = brAddr
        if alias != "" {
            newDevice.alias = alias
        }
        try? viewContext.save()
        presentationMode.wrappedValue.dismiss()
    }
    
    private func delDevice() {
        viewContext.delete(editDevice!)
        try? viewContext.save()
        editDevice = nil
        presentationMode.wrappedValue.dismiss()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        FormSheet(editDevice: .constant(nil)).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
