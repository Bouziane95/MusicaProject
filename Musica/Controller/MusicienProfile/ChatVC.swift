//
//  ChatVC.swift
//  Musica
//
//  Created by Bouziane Bey on 03/02/2020.
//  Copyright © 2020 Bouziane Bey. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ChatVC: UIViewController {
    
    @IBOutlet weak var inputTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func sendBtnPressed(_ sender: Any) {
        //handleSend()
    }
    
    
    func handleSend(){
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let values = ["text": inputTextField.text!]
        childRef.updateChildValues(values)
    }
    
}
