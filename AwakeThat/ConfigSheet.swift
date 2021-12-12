//
//  ConfigSheet.swift
//  AwakeThat
//
//  Created by Krystian Postek on 07/08/2021.
//

import SwiftUI

struct FormSheet: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode
    
    @Binding var editDevice: DeviceWake?
    @State var macAddr: String = ""
    @State var brAddr: String = ""
    @State var alias: String = ""
    @State var icon: String = ""

    // Helper
    @State private var previousInputSize: Int = 0
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Device Properties")) {
                    TextField("MAC address", text: $macAddr)
                        .onChange(of: macAddr, perform: { value in
                            if macAddr.count > 17 {
                                macAddr = String(value.dropLast())
                            }
                            
                            if previousInputSize < macAddr.count { // enabled only when amount of text increases
                                macAddr = value.uppercased()
                                if !value.suffix(2).contains(":") && value.suffix(2).count == 2 && value.count < 16 {
                                    macAddr += ":"
                                }
                            }
                            previousInputSize = macAddr.count
                        })
                    TextField("Broadcast address", text: $brAddr)
                        .keyboardType(.decimalPad)
                        .onChange(of: brAddr, perform: { value in
                            brAddr = value.replacingOccurrences(of: ",", with: ".")
                        })
                    TextField("Alias", text: $alias)
                    Picker("Icon", selection: $icon) {
                        ForEach([""] + SelectableIcon.iconsNames, id: \.self) {
                            if ($0 != "") {
                                Label(SelectableIcon.getDescription($0), systemImage: $0)
                            } else {
                                Label("None", systemImage: "questionmark.square.dashed")
                            }
                        }
                    }
                }
                Section {
                    Button(action: addDevice) {
                        Label("Save", systemImage: "square.and.arrow.down.on.square.fill")
                            .disabled(isInvalid)
                    }
                    if let _ = editDevice {
                        Button(action: delDevice) {
                            Label("Delete", systemImage: "trash")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .navigationTitle(editDevice != nil ? "Edit device" : "Add device")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button(action: { presentationMode.wrappedValue.dismiss() }) {
                Text("Hide")
            })
        }
        .task {
            if let edDev = editDevice {
                macAddr = edDev.macAddr!
                brAddr = edDev.brAddr!
                alias = edDev.alias ?? ""
                icon = edDev.icon ?? ""
            }
        }
        .onDisappear() {
            if editDevice != nil {
                resetFields()
            }
        }
    }

    private func addDevice() {
        let newDevice = (editDevice == nil) ? DeviceWake(context: viewContext) : editDevice!
        newDevice.macAddr = macAddr
        newDevice.brAddr = brAddr
        newDevice.alias = alias == "" ? nil : alias
        newDevice.icon = icon == "" ? nil : icon
        
        try? viewContext.save()
        presentationMode.wrappedValue.dismiss()
    }
    
    private func delDevice() {
        presentationMode.wrappedValue.dismiss()
        let copy = editDevice!
        editDevice = nil
        viewContext.delete(copy)
        try? viewContext.save()
    }
    
    private var isInvalid: Bool {
        var isOk = true
        
        isOk = macAddr.split(separator: ":").map { sub -> Substring in
            isOk = sub.count == 2 && isOk
            return sub
        }.count == 6 && isOk
        
        isOk = brAddr.split(separator: ".").map { sub -> Substring in
            isOk = sub.count < 4 && sub.count > 0 && isOk
            return sub
        }.count == 4 && isOk
        
        return !isOk
    }
    
    private func resetFields() {
        editDevice = nil
        macAddr = ""
        brAddr = ""
        alias = ""
        icon = ""
    }
}

struct ConfigSheet_Previews: PreviewProvider {
    static var previews: some View {
        HStack {}
            .sheet(isPresented: .constant(true), content: {
                FormSheet(editDevice: .constant(nil)).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            })
    }
}
