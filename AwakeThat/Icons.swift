//
//  Icons.swift
//  AwakeThat
//
//  Created by Krystian Postek on 07/08/2021.
//

import SwiftUI

public struct SelectableIcon {
    public static func getDescription(_ imgName: String) -> String {
        if imgName == "" {
            return "None"
        }
        
        let index = self.iconsNames.firstIndex(of: imgName)!
        return [
            "PC", "iMac", "Mac Pro trash bin", "Mac Pro cheese grater", "Server", "Tower", "Laptop"
        ][index]
    }
    
    static let iconsNames = [
        "pc", "desktopcomputer", "macpro.gen2", "macpro.gen3", "xserve", "airport.extreme.tower", "laptopcomputer"
    ]
}

/*
 Label("PC", systemImage: "pc").tag(0)
 Label("iMac", systemImage: "desktopcomputer").tag(1)
 Label("Mac Pro trashbin", systemImage: "macpro.gen2").tag(2)
 Label("Mac Pro cheese", systemImage: "macpro.gen3").tag(3)
 Label("Server", systemImage: "xserve").tag(4)
*/
