//
//  WakingUp.swift
//  AwakeThat
//
//  Created by Krystian Postek on 07/08/2021.
//

import Awake
import Loaf
import UIKit

extension DeviceWake {
    func awakeDevice(useLoaf: Bool = true) {
        let awDevice = Awake.Device(MAC: self.macAddr!, BroadcastAddr: self.brAddr!, Port: UInt16(self.port))
        _ = Awake.target(device: awDevice)
        
        if useLoaf {
            Loaf("Magic packet sent!", state: .success, sender: UIApplication.shared.windows.filter {$0.isKeyWindow}.first!.rootViewController!).show()
        }
    }
}
