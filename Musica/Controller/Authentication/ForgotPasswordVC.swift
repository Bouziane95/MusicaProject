//
//  ForgotPasswordVC.swift
//  Musica
//
//  Created by Bouziane Bey on 21/04/2020.
//  Copyright © 2020 Bouziane Bey. All rights reserved.
//

import UIKit
import Firebase

class ForgotPasswordVC: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func BtnPressed(_ sender: Any) {
        passwordForgot()
    }
    
    func displayAlertMessage(title: String, msg: String){
                let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok",style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
    
    func passwordForgot(){
        if emailTextField.text != nil {
            Auth.auth().sendPasswordReset(withEmail: emailTextField.text!) { (error) in
                if error != nil {
                    self.displayAlertMessage(title: "Problème", msg: "L'adresse mail n'est pas valide.")
                    print(error!)
                } else {
                    self.displayAlertMessage(title: "Reset mot de passe", msg: "Veuillez vérifier vos email (N'oubliez pas les indésirables).")
                }
            }
        } else {
            displayAlertMessage(title: "Problème", msg: "Veuillez entrer votre adresse mail.")
        }
    }
}
