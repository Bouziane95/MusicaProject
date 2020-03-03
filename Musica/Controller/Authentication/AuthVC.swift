//
//  AuthVC.swift
//  Musica
//
//  Created by Bouziane Bey on 19/11/2019.
//  Copyright © 2019 Bouziane Bey. All rights reserved.
//

import UIKit
import Firebase

class AuthVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if Auth.auth().currentUser != nil{
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func signInEmailBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "showLogin", sender: self)
    }
    
    @IBAction func createAccBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "showCreate", sender: self)
    }
    
}
