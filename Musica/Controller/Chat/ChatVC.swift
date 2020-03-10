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
    
    var toID: String?
    @IBOutlet weak var inputTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func sendBtnPressed(_ sender: Any) {
        handleSend()
    }

    func handleSend(){
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let timestamp = Int(Date().timeIntervalSince1970)
        let fromId = Auth.auth().currentUser!.uid
        let toId = toID!
        let values = ["text": inputTextField.text!, "fromId": fromId, "toId" : toId, "timestamp": timestamp] as [String : Any]
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error ?? "")
                return
            }
            guard let messageId = childRef.key else {return}
            let userMessagesRef = Database.database().reference().child("userMessages").child(fromId).child(messageId)
            userMessagesRef.setValue(1)
            
            let dataUserMessagesRef = Database.database().reference().child("userMessages").child(toId).child(messageId)
            dataUserMessagesRef.setValue(1)
        }
    }
    
}
