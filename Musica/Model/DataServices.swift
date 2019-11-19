//
//  DataServices.swift
//  Musica
//
//  Created by Bouziane Bey on 19/11/2019.
//  Copyright © 2019 Bouziane Bey. All rights reserved.
//

import Foundation
import Firebase

let dB_Base = Database.database().reference()

class DataServices {
    static let instance = DataServices()
    
    private var ref_base = dB_Base
    private var ref_users = dB_Base.child("users")
    
    var REF_BASE: DatabaseReference{
        return ref_base
    }
    
    var REF_USERS: DatabaseReference{
        return ref_users
    }
    
    func createDBUsers(unikID: String, userData: Dictionary<String, Any>){
        ref_users.child(unikID).updateChildValues(userData)
    }
   
}
