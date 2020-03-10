//
//  ChatTableView.swift
//  Musica
//
//  Created by Bouziane Bey on 05/03/2020.
//  Copyright © 2020 Bouziane Bey. All rights reserved.
//

import UIKit
import Firebase

class ChatTableView: UITableViewController {
    
    var messages = [Message]()
    var messagesDictionnary = [String: Message]()
    private var dispatchQueue: DispatchQueue = DispatchQueue(label: "ChatTableview")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeUserMessages()
        navigationItem.title = "Chat"
    }
    
    func observeUserMessages(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference().child("userMessages").child(uid)
        ref.observe(.childAdded) { (snapshot) in
            let messageId = snapshot.key
            let messageReference = Database.database().reference().child("messages").child(messageId)
            messageReference.observeSingleEvent(of: .value) { (snapshot) in
                if let dictionnary = snapshot.value as? [String: AnyObject]{
                    let message = Message(dictionary: dictionnary)
                    //To load all messages of a conversation into one cell
                    if let toID = message.toId{
                        self.messagesDictionnary[toID] = message
                        self.messages = Array(self.messagesDictionnary.values)
                            //To sort all messages by time (Newest to the Oldest)
                        self.messages.sort { (message1, message2) -> Bool in
                            return message1.timestamp.int32Value > message2.timestamp.int32Value
                        }
                    }
                    DispatchQueue.main.async(execute: {
                        self.tableView.reloadData()
                    })
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! ChatTableviewCell
        let message = messages[indexPath.row]
        if let toId = message.toId {
            let ref = Database.database().reference().child("users").child(toId)
            ref.observeSingleEvent(of: .value) { (snapshot) in
                if let dictionnary = snapshot.value as? [String: AnyObject]{
                    cell.nameProfil.text = dictionnary["name"] as? String
                }
                self.dispatchQueue.async {
                    if let dictionnary = snapshot.value as? [String: AnyObject]{
                        let arrayUrl = URL(string: dictionnary["profileImgURL"] as! String)!
                        let arrayData = try! Data(contentsOf: arrayUrl)
                        let img = UIImage(data: arrayData)
                        
                        DispatchQueue.main.async {
                            cell.imageProfil.image = img!
                        }
                    }
                }
            }
        }
        if let seconds = message.timestamp?.doubleValue{
            let timestampDate = NSDate(timeIntervalSince1970: seconds)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm:ss a"
            cell.timeLbl.text = dateFormatter.string(from: timestampDate as Date)
        }
       
        
        cell.msgProfil.text = message.text
        return cell
        
    }
}

