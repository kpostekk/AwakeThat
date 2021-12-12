//
//  ContentView.swift
//  AwakeThat
//
//  Created by Krystian Postek on 07/08/2021.
//

import AlertToast
import Awake
import CoreData
import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var showingSheet = false
    @State private var showingSettings = false
    @State private var showingToast = false

    @State private var editingDevice: DeviceWake?
    @AppStorage("fisrtRun") var firstRun = true

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
                            Button(action: { showEditSheet(device) }) {
                                Label("Edit", systemImage: "pencil")
                            }
                        }))
                }
            }
            .navigationTitle("Devices")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { showingSettings.toggle() }, label: {
                        Label("Settings", systemImage: "gear")
                    })
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: showSheet, label: {
                        Label("Add", systemImage: "plus")
                    })
                }
            }
        }
        .sheet(isPresented: $showingSheet) {
            FormSheet(editDevice: $editingDevice)
        }
        .sheet(isPresented: $showingSettings) {
            SettingsSheet()
        }
        .toast(isPresenting: $firstRun) {
            AlertToast(displayMode: .banner(.pop), type: .regular, title: "Hello! 👋", subTitle: "Feel free to add a new device!")
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(firstRun: false)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
