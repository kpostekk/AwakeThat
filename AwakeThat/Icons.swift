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
            "PC", "iMac", "Mac Pro trash bin", "Mac Pro cheese grater", "Cheese grater on a rack", "Server", "Tower", "Laptop", "Printer"
        ][index]
    }
    
    static let iconsNames = [
        "pc", "desktopcomputer", "macpro.gen2", "macpro.gen3", "macpro.gen3.server", "xserve", "airport.extreme.tower", "laptopcomputer", "printer"
    ]
}
