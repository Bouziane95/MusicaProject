//
//  AuthService.swift
//  Musica
//
//  Created by Bouziane Bey on 19/11/2019.
//  Copyright © 2019 Bouziane Bey. All rights reserved.
//

import Foundation
import Firebase

class AuthService {
    
    static let instance = AuthService()
    
    func registerUser(withEmail email: String, andPassword password: String, gender: [String], name: String, age: String, musicStyle: [String], userCreationComplete: @escaping(_ status: Bool, _ error: Error?) -> ()){
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            guard user != nil else {
                userCreationComplete(false, error)
                return
            }
            
            let userData = ["email": email, "name" : name, "age" : age, "musicStyle" : musicStyle, "sex" : gender] as [String : Any]
            
            DataServices.instance.createDBUsers(unikID: Auth.auth().currentUser!.uid, userData: userData)
            userCreationComplete(true, nil)
        }
    }
    
    func loginUser(withEmail email: String, andPassword password: String, loginComplete: @escaping(_ status: Bool, _ error: Error?) -> ()){
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                loginComplete(false, error)
                return
            }
            loginComplete(true, nil)
        }
    }
}
