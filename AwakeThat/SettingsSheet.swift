//
//  SettingsSheet.swift
//  AwakeThat
//
//  Created by Krystian Postek on 08/08/2021.
//

import SwiftUI

struct SettingsSheet: View {
    @Environment(\.presentationMode) private var presentationMode
    
    @AppStorage("ping.interval") private var pingInterval: String = "0.5"
    @AppStorage("ping.timeout") private var pingTimeout: String = "4"
    @AppStorage("ping.enable") private var pingEnable: Bool = true
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Pinging")) {
                    Picker("Ping interval", selection: $pingInterval) {
                        Text("0.25s").tag("0.25")
                        Text("0.5s").tag("0.5")
                        ForEach(1..<5) {
                            Text("\($0)s").tag("\($0)")
                        }
                    }
                    Picker("Ping timeout", selection: $pingTimeout) {
                        ForEach(2..<17) {
                            Text("\($0)s").tag("\($0)")
                        }
                    }
                    Toggle("Enable pinging", isOn: $pingEnable)
                }
                Section(header: Text("About")) {
                    PropertyView(key: "Author", val: .constant("Krystian Postek"))
                    PropertyView(key: "Github", val: .constant("@kpostekk"))
                    PropertyView(key: "Version", val: .constant(Bundle.main.infoDictionary!["CFBundleShortVersionString"]! as! String))
                }
                Section {
                    Button("Reset settings") {
                        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
                        UserDefaults.standard.synchronize()
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button(action: { presentationMode.wrappedValue.dismiss() }) {
                Text("Hide")
            })
        }
    }
}

struct SettingsSheet_Previews: PreviewProvider {
    static var previews: some View {
        SettingsSheet()
    }
}
