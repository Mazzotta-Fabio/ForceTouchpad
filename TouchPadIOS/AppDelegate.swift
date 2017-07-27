//
//  AppDelegate.swift
//  TouchPadIOS
//
//  Created by Fabio Mazzotta on 25/05/17.
//  Copyright © 2017 Fabio Mazzotta. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var urlFile:URL!
    var filename="Configuration"
    
    //questo codice verrà eseguito ogni volta che le Quick Actions verranno eseguite
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        print("ho attivato il 3dTouch")
        if shortcutItem.type == "com.sbeff.TiltControl"{
            //incapsula tutto il grafo delle view controller dell 'app nell'interface Builder
            let sb2=UIStoryboard(name: "Main", bundle: nil)
            //qua prendiamo la nostra view che ci serve
            let addtilt2=sb2.instantiateViewController(withIdentifier: "moviment") as! TiltSensed
            //qui accediamo al nostro navigation che rappresenta il nostro punto di partenza 
            // in cui vi sono anche le altre view
            let navigationController = window?.rootViewController as? UINavigationController
            //qui prendiamo la nostra view all'interno del navigation Controller
            navigationController?.pushViewController(addtilt2, animated: true)

        }
        else{
            if shortcutItem.type == "com.sbeff.apriTouch"{
                let sb2=UIStoryboard(name: "Main", bundle: nil)
                let addtilt2=sb2.instantiateViewController(withIdentifier: "tocco3d") as! PositionTouch
                let navigationController = window?.rootViewController as? UINavigationController
                navigationController?.pushViewController(addtilt2, animated: true)
            }
        }
    }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        print("Sto andando all'inizio")
        self.urlFile=localizzaFile()
        if(FileManager.default.fileExists(atPath: urlFile.absoluteString)){
            print("sono in scrivi")
            scriviDati(height: 667, width: 375, lightPressure: 0.25, strongPressure: 0.5, address: "172.19.0.189", xminrot: 0.15, xmaxrot: 0.80, yminrot: 0.25, ymaxrot: 0.5)
        }
        print(self.urlFile.absoluteString)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        print("sto andando in background")
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        let myDictionary=leggiDati()
        let address=myDictionary["IPAddress"] as! String
        let width=myDictionary["Width"] as! Double
        let height=myDictionary["Height"] as! Double
        let forceLight=myDictionary["LightPressure"] as! Double
        let forceStrong=myDictionary["StrongPressure"] as! Double
        let xminrot=myDictionary["XMinRot"] as! Double
        let xmaxrot=myDictionary["XMaxRot"] as! Double
        let yminrot=myDictionary["YMinRot"] as! Double
        let ymaxrot=myDictionary["YMaxRot"] as! Double
        scriviDati(height: height, width: width, lightPressure: forceLight, strongPressure: forceStrong, address: address, xminrot: xminrot, xmaxrot: xmaxrot, yminrot: yminrot, ymaxrot: ymaxrot)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("sono in terminate")
        let myDictionary=leggiDati()
        let address=myDictionary["IPAddress"] as! String
        let width=myDictionary["Width"] as! Double
        let height=myDictionary["Height"] as! Double
        let forceLight=myDictionary["LightPressure"] as! Double
        let forceStrong=myDictionary["StrongPressure"] as! Double
        let xminrot=myDictionary["XMinRot"] as! Double
        let xmaxrot=myDictionary["XMaxRot"] as! Double
        let yminrot=myDictionary["YMinRot"] as! Double
        let ymaxrot=myDictionary["YMaxRot"] as! Double
        scriviDati(height: height, width: width, lightPressure: forceLight, strongPressure: forceStrong, address: address, xminrot: xminrot, xmaxrot: xmaxrot, yminrot: yminrot, ymaxrot: ymaxrot)
    }
    
    
    //scrive i dati sul file
    func scriviDati(height: Double,width: Double, lightPressure: Double, strongPressure: Double, address: String, xminrot:Double, xmaxrot:Double, yminrot:Double, ymaxrot:Double){
        print("sto scrivendo")
        let myDictionary=leggiDati()
        if(height > 0){
            myDictionary.setValue(height, forKey: "Height")
        }
        if(width > 0){
            myDictionary.setValue(width, forKey: "Width")
        }
        
        if(lightPressure > 0){
            myDictionary.setValue(lightPressure, forKey: "LightPressure")
        }
        if(strongPressure > 0){
            myDictionary.setValue(strongPressure, forKey: "StrongPressure")
        }
        
        if(!(address == "")){
            myDictionary.setValue(address, forKey: "IPAddress")
        }
        if(xminrot.isFinite){
            myDictionary.setValue(xminrot, forKey: "XMinRot")
        }
        if(xmaxrot.isFinite){
           myDictionary.setValue(xmaxrot, forKey: "XMaxRot")
        }
        if(yminrot.isFinite){
          myDictionary.setValue(yminrot, forKey: "YMinRot")
        }
        if(yminrot.isFinite){
          myDictionary.setValue(ymaxrot, forKey: "YMaxRot")
        }
        myDictionary.write(to: urlFile, atomically: true)
    }
    
    
    func localizzaFile() ->URL{
        print("sono il localizza file")
        //localizza e crea in maniera opzianale delle directory in un una locazione e restituisce un oggetto URL
        let documents = try! FileManager.default.url(for: FileManager.SearchPathDirectory.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        //nuova url con il nome del file
        let urlFile=documents.appendingPathComponent(filename).appendingPathExtension("plist")
        return urlFile
    }
    
    //legge i dati sul file
    func leggiDati()->NSMutableDictionary{
        print("leggendo")
        let myDictionary=NSMutableDictionary(contentsOf: urlFile)
        return myDictionary ?? ["":""]
    }
}

