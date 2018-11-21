//
//  VCCoreData.swift
//  pushNotification
//
//  Created by Adrian Pascual Dominguez on 11/19/18.
//  Copyright © 2018 Adrian Pascual Dominguez. All rights reserved.
//

import UIKit
import CoreData

class VCCoreData: UIViewController {
    
    var tasks: [Name] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    

    
    @IBOutlet weak var NombreCd: UITextField!
    @IBOutlet weak var nombreshow: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    


    
    @IBAction func GuardarNombre(_ sender: Any) {
        let contexto = conexionCoreData()
        let entidaddeRespuestas = NSEntityDescription.entity(forEntityName: "Name", in: contexto)
        let nuevaRespuesta = NSManagedObject(entity: entidaddeRespuestas!, insertInto: contexto)
        nuevaRespuesta.setValue( NombreCd.text , forKey: "name")
        nuevaRespuesta.setValue(false, forKey: "flag")
        do {
            try contexto.save()
            print ("Guardado")
        } catch let error as NSError {
            print("No se pudo guardar",error)
        }
    }
    
    
    
    //Name  Entity = name
    func conexionCoreData () -> NSManagedObjectContext {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
    }
  
    
    
    
    
    
}
