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

class ChatVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
    var nameFromChatTV: String?
    var toID: String?
    var messages = [Message]()
    var idIndexpath : String?
    
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = nameFromChatTV
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        observeMessages()
    }
    
    @IBAction func sendBtnPressed(_ sender: Any) {
        handleSend()
    }

    func handleSend(){
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let timestamp = Int(Date().timeIntervalSince1970)
        let fromId = Auth.auth().currentUser!.uid
        let toId = idIndexpath!
        let values = ["text": inputTextField.text!, "fromId": fromId, "toId" : toId, "timestamp": timestamp] as [String : Any]
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error ?? "")
                return
            }
            self.inputTextField.text = nil
            guard let messageId = childRef.key else {return}
            let userMessagesRef = Database.database().reference().child("userMessages").child(fromId).child(messageId)
            userMessagesRef.setValue(1)
            
            let dataUserMessagesRef = Database.database().reference().child("userMessages").child(toId).child(messageId)
            dataUserMessagesRef.setValue(1)
        }
    }
    
    func observeMessages(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let userMsgRef = Database.database().reference().child("userMessages").child(uid)
        userMsgRef.observe(.childAdded) { (snapshot) in
            let messagesID = snapshot.key
            let messagesRef = Database.database().reference().child("messages").child(messagesID)
            messagesRef.observeSingleEvent(of: .value) { (snapshot) in
                guard let dictionnary = snapshot.value as? [String: AnyObject] else {
                    return
                }
                let message = Message(dictionary: dictionnary)
                if message.chatPartnerID() == self.idIndexpath{
                        self.messages.append(message)
                        DispatchQueue.main.async(execute: {
                            self.collectionView.reloadData()
                        })
                    }
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        if let text = messages[indexPath.item].text{
            height = frameMsgTxt(text: text).height + 35
        }
        return CGSize(width: view.frame.width, height: height)
    }
    
    func frameMsgTxt(text: String) -> CGRect{
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)], context: nil)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
       }
    
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ChatMessageCell
        let message = messages[indexPath.item]
        cell.txtView.text = message.text
        cell.widthAnchor.constraint(equalToConstant: frameMsgTxt(text: message.text!).width + 40).isActive = true
        return cell
       }
    
}
