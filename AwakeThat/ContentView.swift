//
//  ContentView.swift
//  AwakeThat
//
//  Created by Krystian Postek on 07/08/2021.
//

import Awake
import CoreData
import Loaf
import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var showingSheet = false
    @State private var editingDevice: DeviceWake?

    @FetchRequest(sortDescriptors: [
        NSSortDescriptor(keyPath: \DeviceWake.alias, ascending: true)
    ], animation: .default)
    private var devices: FetchedResults<DeviceWake>
    
    var body: some View {
        NavigationView {
            List(devices) { device in
                NavigationLink(destination: DeviceDetailsView(device: device)) {
                    DeviceRow(device: device)
                    .contextMenu(ContextMenu(menuItems: {
                        Button(action: { device.awakeDevice() }) {
                            Label("Send magic packet", systemImage: "power")
                        }
                        Button(action: { showEditSheet(device) }) {
                            Label("Edit", systemImage: "pencil")
                        }
                    }))
                }
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
