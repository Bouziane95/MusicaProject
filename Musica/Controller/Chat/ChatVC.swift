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

class ChatVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    var nameFromChatTV: String?
    var imgFromChatTV: String?
    var messages = [Message]()
    var idIndexpath : String?
    private var dispatchQueue: DispatchQueue = DispatchQueue(label: "messageImg")

    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = nameFromChatTV
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        observeMessages()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func sendBtnPressed(_ sender: Any) {
        handleSend()
    }
    @IBAction func sendImgBtnPressed(_ sender: Any) {
        handleUploadImg()
    }
    
    @objc func keyboardWillShow(notification: NSNotification){
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= keyboardFrame.height
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func handleUploadImg(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            uploadToFirebaseImage(imageSelected: pickedImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    private func uploadToFirebaseImage(imageSelected: UIImage){
        let imageName = UUID().uuidString
        let ref = Storage.storage().reference().child("messageImages").child(imageName)
        if let uploadData = imageSelected.jpegData(compressionQuality: 0.2){
            ref.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    print(error!)
                    return
                }
                ref.downloadURL { (url, error) in
                    if let err = error{
                        print(err)
                        return
                    }
                    self.sendMessageWithImageUrl(imageUrl: url?.absoluteString ?? "", image: imageSelected)
                }
            }
        }
    }
    
     func sendMessageWithImageUrl(imageUrl: String, image: UIImage){
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let timestamp = Int(Date().timeIntervalSince1970)
        let fromId = Auth.auth().currentUser!.uid
        guard let toId = idIndexpath else {return}
        let values = ["imageUrl": imageUrl, "fromId": fromId, "toId" : toId, "timestamp": timestamp, "imageWidth": image.size.width, "imageHeight": image.size.height] as [String : Any]
        
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error ?? "")
                return
            }
            self.inputTextField.text = nil
            guard let messageId = childRef.key else {return}
            
            let userMessagesRef = Database.database().reference().child("userMessages").child(fromId).child(messageId).child(toId)
            userMessagesRef.setValue(1)
            
            let dataUserMessagesRef = Database.database().reference().child("userMessages").child(toId).child(messageId).child(fromId)
            dataUserMessagesRef.setValue(1)
        }
    }
    
    func handleSend(){
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let timestamp = Int(Date().timeIntervalSince1970)
        let fromId = Auth.auth().currentUser!.uid
        guard let toId = idIndexpath else {return}
        let values = ["text": inputTextField.text!, "fromId": fromId, "toId" : toId, "timestamp": timestamp] as [String : Any]
        
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error ?? "")
                return
            }
            self.inputTextField.text = nil
            guard let messageId = childRef.key else {return}
            
            let userMessagesRef = Database.database().reference().child("userMessages").child(fromId).child(messageId).child(toId)
            userMessagesRef.setValue(1)
            
            let dataUserMessagesRef = Database.database().reference().child("userMessages").child(toId).child(messageId).child(fromId)
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
                            //scrolling to the last message
                            let indexpath = NSIndexPath(item: self.messages.count - 1, section: 0)
                            self.collectionView.scrollToItem(at: indexpath as IndexPath, at: .bottom, animated: true)
                        })
                    }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //Width and Height of the collection view Cell
        var height: CGFloat = 80
        let width: CGFloat = view.frame.width
        let message = messages[indexPath.item]
        
        if messages[indexPath.item].text != nil{
            height = frameMsgTxt(text: messages[indexPath.item].text!).height + 35
        } else if let imageWidth = message.imageWidth?.floatValue, let imageHeight = message.imageHeight?.floatValue{
            height = CGFloat(imageHeight / imageWidth * 300)
        }
        return CGSize(width: width, height: height)
    }
    
    //func to change the width and height of a message based on how long is it
    func frameMsgTxt(text: String) -> CGRect{
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)], context: nil)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
       }
    
    private func setupChatCell(cell: ChatMessageCell, message: Message){
        //if else statement to get the userImg next to the grey bubble chat
        if message.fromId == Auth.auth().currentUser?.uid{
            
            cell.txtView.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
            cell.txtView.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.userImg.isHidden = true
            cell.txtView.rightAnchor.constraint(equalTo: cell.mainView.rightAnchor , constant: 5).isActive = true
            cell.txtView.leftAnchor.constraint(equalTo: cell.mainView.leftAnchor , constant: 250).isActive = true
            cell.txtView.textAlignment = .center
        } else {
            cell.widthAnchor.constraint(equalToConstant: frameMsgTxt(text: message.text!).width + 100).isActive = true
            cell.txtView.textAlignment = .center
            cell.txtView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            cell.txtView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            dispatchQueue.async {
                let url = URL(string: self.imgFromChatTV!)
                let data = try! Data(contentsOf: url!)
                let img = UIImage(data: data)
                DispatchQueue.main.async {
                    cell.userImg.image = img!
                }
            }
        }
        
        if message.text != nil {
            cell.txtView.text = message.text
            cell.imgMessage.isHidden = true
            cell.txtView.isHidden = false
        } else {
            cell.txtView.isHidden = true
            cell.imgMessage.isHidden = false
            dispatchQueue.async {
                let url = URL(string: message.imageUrl!)
                let data = try! Data(contentsOf: url!)
                let img = UIImage(data: data)
                DispatchQueue.main.async {
                    cell.imgMessage.image = img!
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ChatMessageCell
        let message = messages[indexPath.item]
        cell.txtView.layer.cornerRadius = 16
        cell.imgMessage.layer.cornerRadius = 16
        setupChatCell(cell: cell, message: message)
        return cell
       }
    
}
