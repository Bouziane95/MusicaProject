//
//  Message.swift
//  Musica
//
//  Created by Bouziane Bey on 09/03/2020.
//  Copyright © 2020 Bouziane Bey. All rights reserved.
//

import Foundation
class Message: NSObject {

    var fromId: String?
    var text: String?
    var timestamp: NSNumber!
    var toId: String?
    
    init(dictionary: [String: Any]) {
        self.fromId = dictionary["FromID"] as? String
        self.text = dictionary["text"] as? String
        self.toId = dictionary["toId"] as? String
        self.timestamp = dictionary["timestamp"] as? NSNumber
    }
    
}
