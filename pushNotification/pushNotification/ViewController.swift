//
//  ViewController.swift
//  pushNotification
//
//  Created by Adrian Pascual Dominguez on 11/8/18.
//  Copyright © 2018 Adrian Pascual Dominguez. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseCore
import FirebaseFirestore
import ObjectMapper
import AlamofireObjectMapper


class ViewController: UIViewController {
    let status : [String: Any ] = ["sun" : 1]
    let current = "15"
    var datosEntrada : Entrada?
    var flag : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
      read2()
      listener()
        
    }
    
   
    func read2 () {
        
        let db = Firestore.firestore()
        db.collection("user").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                   // print("\(document.documentID) º=> \(document.data())")
                let valores = ((document.documentID).isEqual(self.current) )
                    //let valores2 = ( NSDictionary(dictionary: document.data()).isEqual(to: self.status) )
                   if valores == true {
                      print ("Succes")
                        let valores = ( NSDictionary(dictionary: document.data()).isEqual(to: self.status) )
                        if valores == true {
                            print ("cumple")
                            self.json()
                       }
                    }
                    else {
                      self.writeData()
                      self.flag = true
                    
                    }
                }
            }
        }
        
    }
    
    func json() {
        //let notificationType = "/PUSH_NOTIF/addNotification"
        let urlString = "http://upaxqaconpubliclb-1385920124.us-east-1.elb.amazonaws.com:8080/ALERTA/getNotificationsReceiver"
        datosEntrada = Entrada()
        datosEntrada?.IdUSer = "16994" //current
        Alamofire.request(urlString, method: .post, parameters: datosEntrada?.getDictionary(), encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            switch response.result {
            case .success:
               self.update()
                print(response)
                if let data = response.data {
                    do {
                        if let jsonArray = try JSONSerialization
                            .jsonObject(with: data, options: []) as? [[String: AnyObject]] {
                            /* perform your ObjectMapper's mapping operation here */
                            let result : [receiver] = Mapper<receiver>().mapArray(JSONArray: jsonArray as [[String : Any]]) //Swift 3
                            print(result)
                            for item in result {
                                print(item.dateCreation!)
                            }
                        } else {
                            print("nel ni madres")
                        }
                    }
                    catch let error as NSError {
                        print(error)
                    }
                }
                break
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func writeData(){
        let db = Firestore.firestore()
       db.collection("user").document(current).setData(["sun" : false])
        {err in
            if let err = err {
                print("Error writing document: \(err)")
            }
        }
        
    }
    
    func update(){
        let userReference = Firestore.firestore().collection("user")
        userReference.document(current).setData(["sun": false])
    }

    func listener () {
        let db = Firestore.firestore()
        db.collection("user").document(current).addSnapshotListener {documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            print("Current data: \(String(describing: document.data()))")
            if document.data() != nil {
                let options = ( NSDictionary(dictionary: document.data()!).isEqual(to: self.status) )
                if options == true {
                    self.json()
                }
            }
        }
    }

    @IBAction func showPopUp(_ sender: Any) {
        let ShowPop = UIStoryboard (name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SBPopUP") as! PopUpViewcontroller
        self.addChild(ShowPop)
        ShowPop.view.frame = self.view.frame
        self.view.addSubview(ShowPop.view)
        ShowPop.didMove(toParent: self)
    }
    
}

