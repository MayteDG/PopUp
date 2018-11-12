//
//  ViewController.swift
//  pushNotification
//
//  Created by Adrian Pascual Dominguez on 11/8/18.
//  Copyright © 2018 Adrian Pascual Dominguez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func showPopUp(_ sender: Any) {
        let ShowPop = UIStoryboard (name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SBPopUP") as! PopUpViewcontroller
        self.addChild(ShowPop)
        ShowPop.view.frame = self.view.frame
        self.view.addSubview(ShowPop.view)
        ShowPop.didMove(toParent: self)
    }
    
}

