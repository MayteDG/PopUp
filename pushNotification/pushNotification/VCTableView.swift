//
//  VCTableView.swift
//  pushNotification
//
//  Created by Adrian Pascual Dominguez on 11/19/18.
//  Copyright © 2018 Adrian Pascual Dominguez. All rights reserved.
//

import UIKit
import CoreData

class VCTableView: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    var nombre :  [Name] = []
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        table.delegate = self
        table.dataSource = self
        mostrarDatos()
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nombre.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        let respuesta = nombre[indexPath.row]
        cell.name?.text = respuesta.name
        return cell
    }
    
    func conexion() -> NSManagedObjectContext {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
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
        

}
