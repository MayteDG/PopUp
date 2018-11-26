//
//  VCTableView.swift
//  pushNotification
//
//  Created by Adrian Pascual Dominguez on 11/19/18.
//  Copyright © 2018 Adrian Pascual Dominguez. All rights reserved.
//

import UIKit
import CoreData
import FirebaseFirestore

class VCTableView: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    
   
    var delegate : listenerprotocol?
    
    var nombre :  [Name] = []
    var selec : Int = 0
    var datosEditar : Name?
    
    
    let status : [String: Any ] = ["sun" : 1]
    let current = "15"
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        table.delegate = self
        table.dataSource = self
      
    mostrarDatos()
    listener()
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
                    self.delegate?.cambio(Status: true)
                }
            }
        }
        
    }
    
    
    
    func conexion() -> NSManagedObjectContext {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nombre.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        let respuesta = nombre[indexPath.row]

        cell.name?.text = respuesta.name
        
        if respuesta.flag {
            cell.name?.text = "💚 \(respuesta.name!)"
        }else{
            cell.name?.text = "❤️ \(respuesta.name!)"
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
    }
    
    private func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let contexto = conexion()
        let res = nombre[indexPath.row]
        
        if editingStyle == .delete {
            contexto.delete(res)
            
            do{
                try contexto.save()
            }catch let error as NSError{
                print("no borro", error)
            }
            
        }
        
        mostrarDatos()
        table.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         selec = indexPath.row
        
    }

    
    @IBAction func eliminar(_ sender: Any) {
        let contexto = conexion()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Name")
        let borrar = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try contexto.execute(borrar)
            print("borro los datos")
            
        } catch let error as NSError  {
            print(" no mostro nada", error)
        }
    }
    
     func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let more = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            print("Eliminado")
            //guardar los cambios de la parte esa
        }
        more.backgroundColor = .lightGray
        
        let favorite = UITableViewRowAction(style: .normal, title: "Marcar como No Leido") { action, index in
            print("favorite button tapped")
        }
        favorite.backgroundColor = .orange
        
        
        return [favorite, more]
    }
    
    
}
