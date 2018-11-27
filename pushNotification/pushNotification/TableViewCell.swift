//
//  TableViewCell.swift
//  pushNotification
//
//  Created by Adrian Pascual Dominguez on 11/19/18.
//  Copyright © 2018 Adrian Pascual Dominguez. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var imagencorazon: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    @IBAction func botonleido(_ sender: Any) {
    }
    
    
    @IBAction func butonEliminar(_ sender: Any) {
    }
}
