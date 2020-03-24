//
//  CurrentUser.swift
//  Musica
//
//  Created by Bouziane Bey on 04/02/2020.
//  Copyright © 2020 Bouziane Bey. All rights reserved.
//

import Foundation

struct CurrentUser{
    let uid: String
    let name: String
    let age: String
    let email: String
    let profileImageUrl: String
    let userMusicStyle : String
    let userGender : String
    let description : String
    
    
    init(uid: String, dictionnary: [String: Any]) {
        self.uid = uid
        self.name = dictionnary["name"] as? String ?? ""
        self.age = dictionnary["age"] as? String ?? ""
        self.email = dictionnary["email"] as? String ?? ""
        self.profileImageUrl = dictionnary["profileImgURL"] as? String ?? ""
        self.userMusicStyle = dictionnary["musicStyle"] as? String ?? ""
        self.userGender = dictionnary["gender"] as? String ?? ""
        self.description = dictionnary["description"] as? String ?? ""
    }
}

