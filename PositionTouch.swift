//
//  PositionTouch.swift
//  TouchPadIOS
//
//  Created by Fabio Mazzotta on 26/05/17.
//  Copyright © 2017 Fabio Mazzotta. All rights reserved.
//

import UIKit
import AudioToolbox
class PositionTouch: UIViewController {
   
    
    
    @IBOutlet var touchView: UIImageView!
    
    
    var x:Double!
    var y:Double!
    var height: Double!
    var width: Double!
    var connectivity:SocketService!
    var forceStrong:Double!
    var forceLight:Double!
    var lightPressure: Bool!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let delegate=UIApplication.shared.delegate as! AppDelegate
        let myDictionary=delegate.leggiDati()
        let address=myDictionary["IPAddress"] as! String
        self.width=myDictionary["Width"] as! Double
        self.height=myDictionary["Height"] as! Double
        self.forceLight=myDictionary["LightPressure"] as! Double
        self.forceStrong=myDictionary["StrongPressure"] as! Double
        
        let widthView=Double(self.view.frame.maxX)
        let heightView=Double(self.view.frame.maxY)
        
        self.touchView.frame=CGRect(x: (widthView-self.width)*0.5, y: (heightView-self.height)*0.5, width: self.width, height: self.height)
        connectivity=SocketService()
        connectivity.connect(host: address, port: 8004)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled=false
    }
    
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if #available(iOS 9.0, *) {
                if traitCollection.forceTouchCapability == UIForceTouchCapability.available {
                    print("ho premuto lo schermo \(touch.location(in: touchView))")
                    let force = Double(touch.force/touch.maximumPossibleForce)
                    print("pressione \(force)")
                    let oldLightPressure=self.lightPressure
                    if(force < forceLight){
                        self.lightPressure = true
                    }
                    else if(force > forceStrong){
                        self.lightPressure=false

                    }
                    
                    if(oldLightPressure != self.lightPressure){
                        if(self.lightPressure){
                            AudioServicesPlaySystemSound(1350)
                        }
                        else{
                            AudioServicesPlaySystemSound(1351)
                        }
                    }
                    
                    let point=touch.location(in: touchView)
                    x=Double(point.x)/self.width
                    y=Double(point.y)/self.height
                    var str:String!
                    if self.lightPressure{
                        str="L"
                    }
                    else{
                        str="S"
                    }
                    let mess = String(x) + " " + String(y) + " " + str + "\n"
                    if(self.connectivity.isAvailableSocket()){
                        self.connectivity.scriviSulSocket(buf: mess)
                    }
                    else{
                        let alertController: UIAlertController = UIAlertController(title: "Warning!", message: "Unable to connect to other device", preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .default) { action in
                            // self.performSegue(withIdentifier: "BackMenuTouch", sender: self)
                        }
                        alertController.addAction(action)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if #available(iOS 9.0, *) {
                if traitCollection.forceTouchCapability == UIForceTouchCapability.available {
                    let force = Double(touch.force/touch.maximumPossibleForce)
                    print("pressione iniziale \(force)")
                    let point=touch.location(in: touchView)
                    x=Double(point.x)/self.width
                    y=Double(point.y)/self.height
                    let mess = String(x) + " " + String(y) + " E\n"
                    if(self.connectivity.isAvailableSocket()){
                        self.connectivity.scriviSulSocket(buf: mess)
                    }
                    else{
                        let alertController: UIAlertController = UIAlertController(title: "Warning!", message: "Unable to connect to other device", preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .default) { action in
                            // self.performSegue(withIdentifier: "BackMenuTouch", sender: self)
                        }
                        alertController.addAction(action)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.lightPressure=true
        if let touch = touches.first {
            if #available(iOS 9.0, *) {
                if traitCollection.forceTouchCapability == UIForceTouchCapability.available {
                    let force = Double(touch.force/touch.maximumPossibleForce)
                    print("pressione iniziale \(force)")
                    let point=touch.location(in: touchView)
                    x=Double(point.x)/self.width
                    y=Double(point.y)/self.height
                    let mess = String(x) + " " + String(y) + " B\n"
                    if(self.connectivity.isAvailableSocket()){
                        self.connectivity.scriviSulSocket(buf: mess)
                    }
                    else{
                        let alertController: UIAlertController = UIAlertController(title: "Warning!", message: "Unable to connect to other device", preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .default) { action in
                            // self.performSegue(withIdentifier: "BackMenuTouch", sender: self)
                        }
                        alertController.addAction(action)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        connectivity.closeSocket(fine: "0")
    }    
}
