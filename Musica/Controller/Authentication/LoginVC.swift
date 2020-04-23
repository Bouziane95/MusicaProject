//
//  LoginVC.swift
//  Musica
//
//  Created by Bouziane Bey on 19/11/2019.
//  Copyright © 2019 Bouziane Bey. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController{
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyBoardWhenTappedAround()
    }
    
    func hideKeyBoardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func displayAlertMessage(title: String, msg: String){
             let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
             let okAction = UIAlertAction(title: "Ok",style: .default, handler: nil)
             alert.addAction(okAction)
             self.present(alert, animated: true, completion: nil)
         }
    
    @IBAction func signInBtnPressed(_ sender: Any) {
        if emailField.text != nil && passwordField.text != nil {
            AuthService.instance.loginUser(withEmail: emailField.text!, andPassword: passwordField.text!) { (success, loginError) in
                if success{
                    print("Success Login")
                    self.performSegue(withIdentifier: "showHome", sender: self)
                } else {
                    self.displayAlertMessage(title: "Oups !", msg: "Votre identifiant ou mot de passe est incorrect")
                    print(String(describing: loginError?.localizedDescription))
                }
            }
        }
    }
    
    @IBAction func passwordForgot(_ sender: Any) {
        performSegue(withIdentifier: "showPassForgotVc", sender: self)
    }
    
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
