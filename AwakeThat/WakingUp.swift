//
//  WakingUp.swift
//  AwakeThat
//
//  Created by Krystian Postek on 07/08/2021.
//

import Awake

extension DeviceWake {
    func awakeDevice(useLoaf: Bool = true) {
        let awDevice = Awake.Device(MAC: self.macAddr!, BroadcastAddr: self.brAddr!, Port: UInt16(self.port))
        _ = Awake.target(device: awDevice)
    }
}
