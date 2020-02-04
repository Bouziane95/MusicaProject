//
//  Message.swift
//  Musica
//
//  Created by Bouziane Bey on 03/02/2020.
//  Copyright © 2020 Bouziane Bey. All rights reserved.
//

import Foundation

class Message {
    private var _content: String
    private var _senderID: String
    
    var content: String{
        return _content
    }
    
    var senderID: String{
        return _senderID
    }
    
    init(content: String, senderID: String) {
        self._content = content
        self._senderID = senderID
    }
}
