//
//  BluetoothService.swift
//  proc
//
//  Created by Fabio Mazzotta on 30/05/17.
//  Copyright © 2017 Fabio Mazzotta. All rights reserved.
//

import UIKit
import CoreBluetooth

class BluetoothService: NSObject ,CBCentralManagerDelegate{
    var centralManager: CBCentralManager!
    var peripheral: CBPeripheralManager!
    var state: String!
    
    override init() {
        super.init()
        self.centralManager=CBCentralManager(delegate: self, queue: nil)
    }
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOff:
            state="bluetooth disattivato"
        case .poweredOn:
            state="bluetooth attivo"
        case .resetting:
            state="connessione momentaneamente persa"
        case .unknown:
            state="stato sconosciuto"
        case .unauthorized:
            state="l'app non è autorizzata ad usare il bluetooth"
        default:
            state="la device non supporta Bluetooth energy"
        }
    }
    
    func getState() -> String {
        return state
    }
}
