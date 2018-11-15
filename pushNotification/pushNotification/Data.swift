//
//  Data.swift
//  pushNotification
//
//  Created by Adrian Pascual Dominguez on 11/14/18.
//  Copyright © 2018 Adrian Pascual Dominguez. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper




class Entrada: NSObject {
    var IdUSer : String
    override init() {
        IdUSer = ""
    }
    func getDictionary () ->  Parameters{
        let result = ["receiverId" : "\(IdUSer)" ]
        return result
    }
   
}


class receiver : Mappable {
    
    var notificationId: NSNumber?
    var senderId: NSNumber?
    var receiverId: NSNumber?
    var title: String?
    var message: String?
    var dateCreation: String?
    var dateReceived: String?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        notificationId <- map["notificationId"]
        senderId <- map["senderId"]
        receiverId <- map["receiverId"]
        title <- map["title"]
        message <- map["message"]
        dateCreation <- map["dateCreation"]
        dateReceived <- map["dateReceived"]
    }
}
    
    
   
 

