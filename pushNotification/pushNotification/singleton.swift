//
//  singleton.swift
//  pushNotification
//
//  Created by Adrian Pascual Dominguez on 12/1/18.
//  Copyright © 2018 Adrian Pascual Dominguez. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore


protocol listenerprotocol  {
    func cambio (Status : Bool)
}


class GlobalVariables {
    static let sharedinstance = GlobalVariables ()
     let status : [String: Any ] = ["sun" : 1]
     var delegate : listenerprotocol?
    private init () {}
    
    func listener () {
     GlobalFunctions.db.collection("user").document("15").addSnapshotListener {documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            print("Current data: \(String(describing: document.data()))")
            if document.data() != nil {
                let options = ( NSDictionary(dictionary: document.data()!).isEqual(to: self.status) )
                if options == true {
                 self.delegate?.cambio(Status: true)
                }
            }
        }
    }
}

class GlobalFunctions: NSObject {
    static let db = Firestore.firestore()
}
