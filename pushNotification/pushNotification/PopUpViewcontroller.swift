//
//  PopUpViewcontroller.swift
//  pushNotification
//
//  Created by Adrian Pascual Dominguez on 11/11/18.
//  Copyright © 2018 Adrian Pascual Dominguez. All rights reserved.
//

import UIKit
import CoreData

class PopUpViewcontroller: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
   
    
    @IBOutlet weak var col: UICollectionView!
    
      var nombre :  [Name] = []
      var selec : Int = 0
      var filtrado : [Name] =  []
      var lugar : Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        col.delegate = self
        col.dataSource = self
        col.register(UINib(nibName: "CVCPopUp", bundle: nil ), forCellWithReuseIdentifier: "CVCPopUp")
        
        mostrarDatos()
        showAnimate()
        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func closePopUp(_ sender: Any) {
       // self.view.removeFromSuperview()
        removeAnimate()
        update()
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
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filtrado.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = col.dequeueReusableCell(withReuseIdentifier: "CVCPopUp", for: indexPath) as! CVCPopUp
        let ejemplo = filtrado[indexPath.row]
        lugar = nombre.count - filtrado.count
       if ejemplo.flag == false {
             cell.lblnombre.text = "💚\(ejemplo.value(forKey: "name") as! String)"
        }
        else {
            cell.lblnombre.text = "❤️\(ejemplo.value(forKey: "name") as! String)"
        }
       
        return cell
    }

    
    func mostrarDatos(){
        let contexto = conexion()
        let fetchRequest : NSFetchRequest<Name> = Name.fetchRequest()
        do {
            nombre = try contexto.fetch(fetchRequest)
            
        } catch let error as NSError {
       print("no mostro nada", error)
        }
        
        filtrado = nombre.filter ({$0.flag == false })
        
        for i in filtrado {
            print (i.name!)
        }
    }
    
    
    func conexion() -> NSManagedObjectContext {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
    }
  
    
    func update () {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let managedContext = appDelegate.persistentContainer.viewContext
    let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Name")
    do
    {
    let test = try managedContext.fetch(fetchRequest)
    let objectUpdate = test[lugar] as! NSManagedObject
    objectUpdate.setValue(true , forKey: "flag")
            do{
                try managedContext.save()
            }catch
                {
            print(error)
        }
        }
        catch
        {
        print(error)
    }
    
    }
}
