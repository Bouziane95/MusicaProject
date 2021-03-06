//
//  Message.swift
//  Musica
//
//  Created by Bouziane Bey on 09/03/2020.
//  Copyright © 2020 Bouziane Bey. All rights reserved.
//

import Foundation
import Firebase

class Message: NSObject {

    var fromId: String?
    var text: String?
    var timestamp: NSNumber!
    var toId: String?
    var imageUrl: String?
    var imageWidth: NSNumber?
    var imageHeight: NSNumber?
    
    init(dictionary: [String: Any]) {
        self.fromId = dictionary["fromId"] as? String
        self.text = dictionary["text"] as? String
        self.toId = dictionary["toId"] as? String
        self.timestamp = dictionary["timestamp"] as? NSNumber
        self.imageUrl = dictionary["imageUrl"] as? String
        self.imageWidth = dictionary["imageWidth"] as? NSNumber
        self.imageHeight = dictionary["imageHeight"] as? NSNumber
    }
    
    func chatPartnerID() -> String? {
        if fromId == Auth.auth().currentUser?.uid{
            return toId ?? ""
        } else {
            return fromId ?? ""
        }
        
    }
}
