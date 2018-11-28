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
import CoreData

import AVKit
import AVFoundation
import MediaPlayer
import AudioToolbox


protocol listenerprotocol  {
    func cambio (Status : Bool)
}


class ViewController: UIViewController, listenerprotocol , AVPlayerViewControllerDelegate{
    
    
    func cambio(Status: Bool) {
        if Status == true {
            self.json()
        }
    }
    var managedObjectContext: NSManagedObjectContext? = nil
    
    let status : [String: Any ] = ["sun" : 1]
    let current = "15"
    var flag : Bool = false
    
    var datosEntrada : EntradaMVNotifications?
    var paramEntrada : ParamNotif?

    var nombre : [Name] = []
    var filtrado : [Name] = []
    
    @IBOutlet weak var progressView: UIProgressView!
   
    var playerController = AVPlayerViewController ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
       listener()
    
        downloadVideo()
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
        let urlString = "http://upaxqaconpubliclb-1385920124.us-east-1.elb.amazonaws.com:8080/ALERTA/markViewNotifications"
        
        datosEntrada = EntradaMVNotifications()
        datosEntrada?.receiverId = 16995 //current
        
        paramEntrada = ParamNotif ()
        paramEntrada?.id = 107
        paramEntrada?.dateViewInitial = "2018-09-04 17:55:14"
        paramEntrada?.dateViewEnd =  "2018-09-04 17:58:00"

        datosEntrada?.notificationsId = (paramEntrada?.getDictionary2())!
        
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
        db.collection("user").document("15").addSnapshotListener {documentSnapshot, error in
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
    
    
    func descargarvide () {
        let videoURL = URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
        let player = AVPlayer(url: videoURL!)
        let playervc = AVPlayerViewController()
        playervc.delegate = self
        playervc.player = player
        self.present(playervc, animated: true) {
            playervc.player!.play()
        }
    }
    
    func downloadVideo(){
        
        Alamofire.request("http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4").downloadProgress(closure : { (progress) in
            print(progress.fractionCompleted)
           self.progressView!.progress = Float(progress.fractionCompleted)
        }).responseData{ (response) in
            print(response)
            print(response.result.value!)
            print(response.result.description)
            if let data = response.result.value {
                
                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let videoURL = documentsURL.appendingPathComponent("video.mp4")
                do {
                    try data.write(to: videoURL)
                } catch {
                    print("Something went wrong!")
                }
                print(videoURL)
                let player = AVPlayer(url: videoURL as URL)
                self.playerController.player = player
                self.addChild(self.playerController)
                self.view.addSubview(self.playerController.view)
                self.playerController.view.frame = self.view.frame
                player.play()
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
    
    
    
    
    func json2() {
       
        let urlString = "http://upaxqaconpubliclb-1385920124.us-east-1.elb.amazonaws.com:8080/ALERTA/markViewNotifications"
        let param = [
            "receiverId": 16995,
            "notifications": [
            "id": 107,
            "dateViewInitial": "2018-09-04 17:55:14",
            "dateViewEnd": "2018-09-04 17:58:00"
            ]] as [String : Any]
        

        Alamofire.request(urlString, method: .post, parameters: param , encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            switch response.result {
            case .success:
                self.update()
                print(response)
                break
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func mostrarDatos(){
        let contexto = conexion()
        let fetchRequest : NSFetchRequest<Name> = Name.fetchRequest()
        do {
            nombre = try contexto.fetch(fetchRequest)
        } catch let error as NSError {
            print("no mostro nada", error)
        }
        filtrado = nombre.filter ({$0.flag == true })
    }
   
    func conexion() -> NSManagedObjectContext {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
    }
    
    
    func comprobarshow () {
        if filtrado.count == 0  {
            print ("Mensajes Vistos")
        }
        else {
            let ShowPop = UIStoryboard (name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SBPopUP") as! PopUpViewcontroller
            self.addChild(ShowPop)
            ShowPop.view.frame = self.view.frame
            self.view.addSubview(ShowPop.view)
            ShowPop.didMove(toParent: self)
        }
    }
}

