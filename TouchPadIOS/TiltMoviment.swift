//
//  TiltMoviment.swift
//  TirocinioTouchPad
//
//  Created by Fabio Mazzotta on 25/05/17.
//  Copyright © 2017 Fabio Mazzotta. All rights reserved.
//

import UIKit
import CoreMotion

class TiltMoviment: UIViewController {
    
    
    @IBOutlet var lblConnessi: UILabel!
    var netWorkService:ConnectivityService!
    var moviment:CMMotionManager!
   
    @IBOutlet var lblY: UILabel!
    @IBOutlet var lblX: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.netWorkService=ConnectivityService()
        
        self.moviment=CMMotionManager()
        
        self.netWorkService.prot=self
        
        //Gestiamo i movimenti
        if moviment.isGyroAvailable{
            //intervallo utilizzato per aggiornare i dati
            moviment.gyroUpdateInterval=0.01
            //iniziamo a settare i movimenti
            moviment.startGyroUpdates(to: .main){ (data,error)
                in
                if(data!.rotationRate.x > 0.7){
                    print("mi sto spostando a destra")
                    self.view.backgroundColor=UIColor.red
                    self.lblX.text="x:\(data!.rotationRate.x)"
                }
                if(data!.rotationRate.y > 0.7){
                    print("mi sto spostando in alto")
                    self.lblY.text="y:\(data!.rotationRate.y)"
                    self.view.backgroundColor=UIColor.yellow
                }
                if(data!.rotationRate.x<(0.7)){
                    print("mi sto spostando a sinistra")
                    self.lblX.text="x:\(data!.rotationRate.x)"
                    self.view.backgroundColor=UIColor.blue
                }
                if(data!.rotationRate.y<(0.7)){
                    print("mi sto spostando in basso")
                    self.lblY.text="y:\(data!.rotationRate.y)"
                    self.view.backgroundColor=UIColor.green
                }
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension TiltMoviment: Mostra{
    func showConnessi(nomi: [String]) {
        OperationQueue.main.addOperation {
            self.lblConnessi.text="Dispositivi Connessi : \(nomi)"
        }
    }
}
