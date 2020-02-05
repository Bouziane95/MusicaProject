//
//  CreateAccVC.swift
//  Musica
//
//  Created by Bouziane Bey on 19/11/2019.
//  Copyright © 2019 Bouziane Bey. All rights reserved.
//

import UIKit
import FirebaseStorage
import Photos
import Firebase


class CreateAccVC: UIViewController {
    
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    @IBOutlet weak var defaultProfileImg: UIImageView!
    @IBOutlet weak var ageTxtField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var imagePicker : UIImagePickerController!
    var imageReference : StorageReference{
        return Storage.storage().reference().child("imgProfiles")
    }
    
    let rockMusicien = ["Guitariste" , "Batteur"]
    let jazzMusicien = ["Contre-Bassiste"]
    let hiphopMusicien = ["Break-Dance"]
    var sectionData: [Int: [String]] = [:]
    var musicStyle = [String]()
    var profilImg : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ageTxtField.delegate = self
        tapImage()
        imagePicker.delegate = self
        hideKeyBoardWhenTappedAround()
        sectionData = [0 : rockMusicien, 1 : jazzMusicien, 2 : hiphopMusicien]
    }
    
    func tapImage(){
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        defaultProfileImg.isUserInteractionEnabled = true
        defaultProfileImg.addGestureRecognizer(imageTap)
        defaultProfileImg.layer.cornerRadius = defaultProfileImg.bounds.height / 2
        defaultProfileImg.clipsToBounds = true
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
    }
    
    func hideKeyBoardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreateAccVC.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
//    func uploadPhoto(){
//        guard let uid = Auth.auth().currentUser?.uid else {return}
//        let storageRef = imageReference.child("\(uid)")
//
//        guard let image = defaultProfileImg.image else {return}
//        guard let imageData = image.jpegData(compressionQuality: 1) else {return}
//
//        let metaData = StorageMetadata()
//        metaData.contentType = "image/jpg"
//
//        let uploadTask = storageRef.putData(imageData, metadata: metaData) { (metadata, error) in
//            print(metadata ?? "NO METADATA")
//            print(error ?? "NO ERROR")
//        }
//        uploadTask.observe(.progress) { (snapshot) in
//            print(snapshot.progress ?? "NO MORE PROGRESS")
//        }
//        uploadTask.resume()
//    }
    
    func uploadPhoto(){
        let storageRef = Storage.storage().reference().child("profileImg")
        if let uploadData = self.defaultProfileImg.image?.pngData(){
            
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    print(error)
                    return
                }
                storageRef.downloadURL { (<#URL?#>, <#Error?#>) in
                    <#code#>
                }
            }
        }
        
    }

    func displayAlertMessage(title: String, msg: String){
          let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
          let okAction = UIAlertAction(title: "Ok",style: .default, handler: nil)
          alert.addAction(okAction)
          self.present(alert, animated: true, completion: nil)
      }
    
    @IBAction func setMusicStyle(_ sender: Any) {
        let SetMusicStyleVC = storyboard?.instantiateViewController(withIdentifier: "SetMusicStyleVC")
        present(SetMusicStyleVC!, animated: true, completion: nil)
    }
    
    @IBAction func createAccPressed(_ sender: Any) {
        if emailTxtField.text != nil && passwordTxtField.text != nil && nameTxtField.text != nil {
            AuthService.instance.registerUser(withEmail: self.emailTxtField.text!, andPassword: passwordTxtField.text!, name: self.nameTxtField.text!, age: self.ageTxtField.text!, profileImage: <#String#>, musicStyle: musicStyle) { (success, registrationError)
                in
                if success{
                    self.uploadPhoto()
                    print("Succes registration")
                    let LoginVc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC")
                    self.present(LoginVc!, animated: true, completion: nil)
                } else {
                    self.displayAlertMessage(title: "Error",msg: "\(registrationError!.localizedDescription)")
                    print(String(describing: registrationError?.localizedDescription))
                }
            }
        }
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension CreateAccVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @objc func openImagePicker(_ sender: Any){
              self.present(imagePicker, animated: true, completion: nil)
          }
          
          func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
              picker.dismiss(animated: true, completion: nil)
          }
          
          func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
              if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
                  self.defaultProfileImg.image = pickedImage
              }
              picker.dismiss(animated: true, completion: nil)
          }
}

extension CreateAccVC: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var startString = ""

        if textField.text != nil {
            startString += textField.text!
        }

        startString += string

        let limitNumber = Int(startString)

        if limitNumber! > 99  {
            return false
        } else {
            return true
        }
    }
}

extension CreateAccVC: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (sectionData[section]?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "musicCell", for: indexPath)
        cell.textLabel?.text = sectionData[indexPath.section]![indexPath.row]
        cell.textLabel?.font = UIFont(name: "Avenir Next", size: 17)
        cell.textLabel?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var headerTitle : String?
        
        if section == 0 {
            headerTitle = "Rock"
        }
        if section == 1 {
            headerTitle = "Jazz"
        }
        if section == 2 {
            headerTitle = "Hip-Hop"
        }
        return headerTitle
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

