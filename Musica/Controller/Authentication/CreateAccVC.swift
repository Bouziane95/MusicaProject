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
        return Storage.storage().reference().child("profileImg")
    }
    
    let rockMusicien = ["Guitariste" , "Batteur"]
    let jazzMusicien = ["Contre-Bassiste"]
    let hiphopMusicien = ["Break-Dance"]
    let sections = ["Rock", "Jazz", "Hip-Hop"]
    var musicStyle = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ageTxtField.delegate = self
        tapImage()
        imagePicker.delegate = self
        hideKeyBoardWhenTappedAround()
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
    
    func uploadPhoto(){
        let storageRef = imageReference
        if let uploadData = self.defaultProfileImg.image?.pngData(){
            
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    print(error!)
                    return
                }
                storageRef.downloadURL { (url, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    let urlString = url!.absoluteString
                    let userData = ["profileImg" : urlString]
                    DataServices.instance.createDBUsers(unikID: Auth.auth().currentUser!.uid, userData: userData)
                }
            }
        }
    }
    
    @IBAction func createAccPressed(_ sender: Any) {
        if emailTxtField.text != nil && passwordTxtField.text != nil && nameTxtField.text != nil {
            AuthService.instance.registerUser(withEmail: self.emailTxtField.text!, andPassword: passwordTxtField.text!, name: self.nameTxtField.text!, age: self.ageTxtField.text!, musicStyle: musicStyle) { (success, registrationError)
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
        switch section {
        case 0 :
            return rockMusicien.count
        case 1 :
            return jazzMusicien.count
        case 2 :
            return hiphopMusicien.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "musicCell", for: indexPath)
        switch indexPath.section{
        case 0 :
            cell.textLabel?.text = rockMusicien[indexPath.row]
            break
        case 1 :
            cell.textLabel?.text = jazzMusicien[indexPath.row]
            break
        case 2 :
            cell.textLabel?.text = hiphopMusicien[indexPath.row]
            break
        default :
            break
        }
        cell.textLabel?.font = UIFont(name: "Avenir Next", size: 17)
        cell.textLabel?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
            switch indexPath.section{
            case 0 :
                musicStyle.remove(at: indexPath.row)
                break
            case 1 :
                musicStyle.remove(at: indexPath.row)
                break
            case 2 :
                musicStyle.remove(at: indexPath.row)
                break
            default :
                break
            }
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
            switch indexPath.section{
            case 0 :
                let newMusicStyle = rockMusicien[indexPath.row]
                musicStyle.append(newMusicStyle)
                break
            case 1 :
                let newMusicStyle = jazzMusicien[indexPath.row]
                musicStyle.append(newMusicStyle)
                break
            case 2 :
                let newMusicStyle = hiphopMusicien[indexPath.row]
                musicStyle.append(newMusicStyle)
                break
            default :
                break
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}



