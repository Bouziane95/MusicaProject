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
    var nameChat : String?
    var imgChat: String?
    private var dispatchQueue: DispatchQueue = DispatchQueue(label: "ChatTableview")
    var idToPass: String?
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeUserMessages()
        getTitle()
    }
    
    func getTitle(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dict = snapshot.value as? [String: Any] else {return}
            let user = CurrentUser(uid: uid, dictionnary: dict)
            let attributes = [NSAttributedString.Key.font: UIFont(name: "Avenir", size: 26)!, NSAttributedString.Key.foregroundColor : UIColor.white]
            self.navigationController?.navigationBar.titleTextAttributes = attributes
            self.navigationItem.title = "\(user.name)"
        }
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
                    if let chatPartnerID = message.chatPartnerID(){
                        self.messagesDictionnary[chatPartnerID] = message
                        self.messages = Array(self.messagesDictionnary.values)
                            //To sort all messages by time (Newest to the Oldest)
                        self.messages.sort { (message1, message2) -> Bool in
                            return message1.timestamp.int32Value > message2.timestamp.int32Value
                        }
                    }
                    self.reloadTable()
                }
            }
        }
    }
    
    func reloadTable(){
        //invalidate = stop the reloadData at each messages coming from firebase until the last msg loaded from firebase then we reloadData
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { (timer) in
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
            })
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        var sectionNumber : Int = 1
        if messages.count > 0 {
            self.tableView.backgroundView = nil
            sectionNumber = 1
        } else {
            let noDataText : UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height))
            noDataText.text = "Aucun chat pour l'instant"
            noDataText.font = UIFont(name: "Marker Felt", size: 28)
            noDataText.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            noDataText.textAlignment = .center
            noDataText.numberOfLines = 0
            self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
            self.tableView.backgroundView = noDataText
        }
        return sectionNumber
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! ChatTableviewCell
        let message = messages[indexPath.row]
        let toId = message.chatPartnerID()
        let ref = Database.database().reference().child("users").child(toId!)
        
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
        
        if let seconds = message.timestamp?.doubleValue{
            let timestampDate = NSDate(timeIntervalSince1970: seconds)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm:ss a"
            cell.timeLbl.text = dateFormatter.string(from: timestampDate as Date)
        }
        cell.msgProfil.text = message.text
        if cell.msgProfil.text == nil {
            cell.msgProfil.text = "Vous avez reçu une image !"
        }
        return cell
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ChatVC{
            destination.nameFromChatTV = nameChat
            destination.idIndexpath = idToPass
            destination.imgFromChatTV = imgChat
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        let chatPartnerID = message.chatPartnerID()
        let ref = Database.database().reference().child("users").child(chatPartnerID!)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let dictionnary = snapshot.value as? [String: AnyObject]{
                self.nameChat = dictionnary["name"] as? String
                self.idToPass = dictionnary["uid"] as? String
                self.imgChat = dictionnary["profileImgURL"] as? String
                self.performSegue(withIdentifier: "showChatVC", sender: self)
            }
        }
    }
}

