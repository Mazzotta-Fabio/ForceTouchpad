//
//  VelocityTouch.swift
//  TouchPadIOS
//
//  Created by Fabio Mazzotta on 26/05/17.
//  Copyright © 2017 Fabio Mazzotta. All rights reserved.
//

import UIKit

class VelocityTouch: UIViewController {

    @IBOutlet var lblconnessi: UILabel!
    @IBOutlet var touchView: UIImageView!
    
    var swipeMoviment: UIPanGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.swipeMoviment=UIPanGestureRecognizer(target: self, action: #selector(handleSwipe))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //testato
    func handleSwipe(sender:UIPanGestureRecognizer){
        print("Spostamento \(sender.location(in: touchView))")
    }
}
