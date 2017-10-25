//
//  TiltSensed.swift
//  TouchPadIOS
//
//  Created by Fabio Mazzotta on 26/05/17.
//  Copyright © 2017 Fabio Mazzotta. All rights reserved.
//

import UIKit
import CoreMotion

class TiltSensed: UIViewController {

    var moviment:CMMotionManager!
    
    private var xminrot:Double!
    private var yminrot:Double!
    private var xmaxrot:Double!
    private var ymaxrot:Double!
    private var touched:Bool!
    
    @IBOutlet var lblX: UILabel!
    
    @IBOutlet var lblConnessi: UILabel!
    
    @IBOutlet var lblY: UILabel!
    
    var connectivity:SocketService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var precX=0.0,precY=0.0

        self.touched=false
        self.connectivity=SocketService()
        
        let delegate=UIApplication.shared.delegate as! AppDelegate
        let myDictionary=delegate.leggiDati()
        let address=myDictionary["IPAddress"] as! String
        self.xminrot=myDictionary["XMinRot"] as! Double
        self.xmaxrot=myDictionary["XMaxRot"] as! Double
        self.yminrot=myDictionary["YMinRot"] as! Double
        self.ymaxrot=myDictionary["YMaxRot"] as! Double
        connectivity.connect(host: address, port: 8004)
        self.moviment=CMMotionManager()
        
        //Gestiamo i movimenti
        if moviment.isDeviceMotionAvailable{
            //intervallo utilizzato per aggiornare i dati
            moviment.deviceMotionUpdateInterval=0.01
            //iniziamo a settare i movimenti
            moviment.startDeviceMotionUpdates(to: .main){(data,error)
                in
                if let attitude=self.moviment.deviceMotion?.attitude{
                    let xo=Double((attitude.roll/Double.pi)+0.5)
                    let x=(xo-self.xminrot!)/(self.xmaxrot!-self.xminrot!)
                    let yo=Double((attitude.pitch/Double.pi)+0.5)
                    let y=(yo-self.yminrot!)/(self.ymaxrot!-self.yminrot!)
                    if(abs(x - precX) > 0.001 || abs(y - precY) > 0.001){
                        let apprX=String(format: "%.3f (%.3f)", x, xo)
                        let apprY=String(format: "%.3f (%.3f)", y, yo)
                        self.lblX.text="X: " + apprX
                        self.lblY.text="Y: " + apprY
                        var flag:String!
                        if(self.touched){
                            flag="T"
                        }
                        else{
                            flag="N"
                        }
                        let mess=String(x) + " " + String(y) + " " + flag + "\n"
                        self.connectivity.scriviSulSocket(buf: mess)
                        precX=x
                        precY=y
                    }
                }
            }
        }

        
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touched=false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       self.touched=true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        connectivity.closeSocket(fine: "0")
    }
}
