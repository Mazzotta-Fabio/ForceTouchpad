//
//  OptionController.swift
//  TouchPadIOS
//
//  Created by Fabio Mazzotta on 26/05/17.
//  Copyright © 2017 Fabio Mazzotta. All rights reserved.
//

import UIKit

class OptionController: UIViewController,UITextFieldDelegate{

    
    @IBOutlet var lblHeight: UILabel!
    
    
    @IBOutlet var lblWidth: UILabel!
    
    @IBOutlet var txtHeight: UITextField!
    
   
    @IBOutlet var txtWidth: UITextField!
    
    @IBOutlet var txtXMinRot: UITextField!
    
    @IBOutlet var txtXmaxRot: UITextField!
    
    @IBOutlet var txtYMinRot: UITextField!
    
    @IBOutlet var txtYMaxRot: UITextField!
    
    @IBOutlet var txtIP: UITextField!
    
    @IBOutlet var txtStrongForce: UITextField!
    
    
    @IBOutlet var txtLightForce: UITextField!
    
    var tastieraFuori=false
    //metodo per nascondere la tastiera:
    
    //prima tocca fuori dalla tastiera
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //questo metodo serve ad impostare le text field al loro stato originale
        self.view.endEditing(true)
    }
    
    /*
    //qui chiediamo al delegato se è stato premuto il tasto di ritorno
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Notifies this object that it has been asked to relinquish its status as first responder in its window
        txtWidth.resignFirstResponder()
        txtHeight.resignFirstResponder()
        return true
    }
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtIP.delegate=self
        txtXmaxRot.delegate=self
        txtXMinRot.delegate=self
        txtWidth.delegate=self
        txtHeight.delegate=self
        txtLightForce.delegate=self
        txtStrongForce.delegate=self
        txtYMinRot.delegate=self
        txtYMaxRot.delegate=self
        
        
        
        lblHeight.text="Height(" + "\(self.view.frame.maxY)" + "):"
        lblWidth.text="Width(" + "\(self.view.frame.maxX)" + "):"
        
        let delegate=UIApplication.shared.delegate as! AppDelegate
        let dictionary=delegate.leggiDati()
        
        txtIP.text=dictionary["IPAddress"] as? String ?? "10.0.0.1"
        
        let width=dictionary["Width"] as? Double ?? 300
        let height=dictionary["Height"] as? Double ?? 400
        let forceLight=dictionary["LightPressure"] as? Double ?? 0.25
        let forceStrong=dictionary["StrongPressure"] as? Double ?? 0.5
        
        let xminrot=dictionary["XMinRot"] as? Double ?? 0
        let xmaxrot=dictionary["XMaxRot"] as? Double ?? 1
        let yminrot=dictionary["YMinRot"] as? Double ?? 0
        let ymaxrot=dictionary["YMaxRot"] as? Double ?? 1
        
        
        txtXmaxRot.text=String(xmaxrot)
        txtXMinRot.text=String(xminrot)
        txtYMaxRot.text=String(ymaxrot)
        txtYMinRot.text=String(yminrot)
        
        txtWidth.text=String(describing: width)
        txtHeight.text=String(height)
        
        txtLightForce.text=String(forceLight)
        txtStrongForce.text=String(forceStrong)
        
        NotificationCenter.default.addObserver(self, selector: #selector(OptionController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(OptionController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    func keyboardWillShow(notification:NSNotification) {
        adjustingHeight(show: true, info: notification.userInfo! as NSDictionary)
    }
    
    func keyboardWillHide(notification:NSNotification) {
        adjustingHeight(show: false, info: notification.userInfo! as NSDictionary)
    }
    
    func adjustingHeight(show:Bool, info: NSDictionary) {
        //qui verifichiamo che la tastiera sia già fuori oppure no
        if((!txtHeight.isEditing)&&(!txtWidth.isEditing)&&(!txtXMinRot.isEditing)&&(!txtXmaxRot.isEditing)){
                guard tastieraFuori != show else{
                    return
                }
                let fineTastiera:CGRect = (info.object(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue).cgRectValue
                let duration: TimeInterval=info.object(forKey: UIKeyboardAnimationDurationUserInfoKey) as! Double
                UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
                    let dimensioneTastiera:CGRect=self.view.convert(fineTastiera, to: nil)
                    let spostamentoVerticale=dimensioneTastiera.size.height * (show ? -1 : 1)
                    self.view.frame=self.view.frame.offsetBy(dx: 0,dy: spostamentoVerticale)
                    self.tastieraFuori = !self.tastieraFuori
                }, completion: nil)
            }
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("sono qui")
        var height:Double=0
        var width:Double=0
        var IP:String=""
        var lightPressure:Double=0
        var strongPressure:Double=0
        var xmaxrot:Double=0
        var xminrot:Double=0
        var yminrot:Double=0
        var ymaxrot:Double=0
        
        
        if(!(self.txtHeight.text == "")){
            print("sono in altezza " + self.txtHeight.text!)
            height=Double(self.txtHeight.text!)!
        }
        
        if(!(self.txtWidth.text == "")){
            print("sono in larghezza " + self.txtWidth.text!)
            width=Double(self.txtWidth.text!)!
        }
        
        if(!(self.txtIP.text == "")){
            print("sono in Ip " + self.txtIP.text!)
            IP=self.txtIP.text!
        }
        
        if(!(self.txtXMinRot.text == "")){
            print("sono in xminrot " + self.txtXMinRot.text!)
            xminrot=Double(self.txtXMinRot.text!)!
        }
        
        if(!(self.txtXmaxRot.text == "")){
            print("sono in XmaxRot " + self.txtXmaxRot.text!)
            xmaxrot=Double(self.txtXmaxRot.text!)!
        }
        
        if(!(self.txtYMinRot.text == "")){
            print("sono in Yminrot" + self.txtYMinRot.text!)
            yminrot=Double(self.txtYMinRot.text!)!
        }
        
        if(!(self.txtYMaxRot.text == "")){
            print("sono in Ymaxrot " + self.txtYMaxRot.text!)
            ymaxrot=Double(self.txtYMaxRot.text!)!
        }
        
        if(!(self.txtStrongForce.text == "")){
            print("sono strong force" + self.txtStrongForce.text!)
            strongPressure=Double(self.txtStrongForce.text!)!
        }
        
        if(!(self.txtLightForce.text == "")){
            print("sono in lightForce " + self.txtLightForce.text!)
            lightPressure=Double(self.txtLightForce.text!)!
        }
        
        let delegate=UIApplication.shared.delegate as! AppDelegate
        delegate.scriviDati(height: height, width: width, lightPressure: lightPressure, strongPressure: strongPressure, address:IP, xminrot: xminrot, xmaxrot: xmaxrot, yminrot: yminrot, ymaxrot: ymaxrot)
    }
}
