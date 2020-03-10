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
    private var dispatchQueue: DispatchQueue = DispatchQueue(label: "ChatTableview")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeMessages()
        navigationItem.title = "Chat"
    }
    
    func observeMessages(){
        let ref = Database.database().reference().child("messages")
        ref.observe(.childAdded) { (snapshot) in
            if let dictionnary = snapshot.value as? [String: AnyObject]{
                let message = Message(dictionary: dictionnary)
                self.messages.append(message)
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
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
        cell.msgProfil.text = message.text
        return cell
        
    }
}

