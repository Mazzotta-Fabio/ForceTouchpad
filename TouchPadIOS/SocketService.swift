//
//  SocketService.swift
//  socket
//
//  Created by Fabio Mazzotta on 01/06/17.
//  Copyright © 2017 Fabio Mazzotta. All rights reserved.
//

import UIKit
import CoreFoundation

class SocketService: NSObject {
    var writeStream:OutputStream!
    var readStream:InputStream!
    var write:Unmanaged<CFWriteStream>?
    var read:Unmanaged<CFReadStream>?
    override init() {
        super.init()
    }
    
    func connect(host: String, port: UInt32){
        let dest=host as CFString
        CFStreamCreatePairWithSocketToHost(nil,dest, port, &read, &write)
        //Gets the value of this unmanaged reference as a managed reference
        //without consuming an unbalanced retain of it.
        self.readStream=read!.takeRetainedValue()
        self.writeStream=write!.takeUnretainedValue()
        self.readStream!.open()
        self.writeStream!.open()
    }
    
    func isAvailableSocket()->Bool{
        if(CFWriteStreamCanAcceptBytes(writeStream)){
            return true
        }
        else{
            return false
        }
    }
    
    func scriviSulSocket(buf: String){
        let lenght=buf.characters.count as CFIndex
        CFWriteStreamWrite(writeStream, buf, lenght)
    }
    
    func closeSocket(fine: String){
        if(self.isAvailableSocket()){
            self.scriviSulSocket(buf: fine)
            CFWriteStreamClose(writeStream)
            CFReadStreamClose(readStream)
        }
    }
}
