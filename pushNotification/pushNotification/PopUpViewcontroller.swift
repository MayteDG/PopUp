//
//  PopUpViewcontroller.swift
//  pushNotification
//
//  Created by Adrian Pascual Dominguez on 11/11/18.
//  Copyright © 2018 Adrian Pascual Dominguez. All rights reserved.
//

import UIKit

class PopUpViewcontroller: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        showAnimate()
        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func closePopUp(_ sender: Any) {
       // self.view.removeFromSuperview()
        removeAnimate()
    }
    
    
    
    func showAnimate () {
        self.view.transform = CGAffineTransform (scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform (scaleX: 1.0, y: 1.0)
            })
    }
    
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    
}
