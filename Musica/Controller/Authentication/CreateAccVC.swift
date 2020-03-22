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
    @IBOutlet weak var userDescription: UITextView!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    @IBOutlet weak var defaultProfileImg: UIImageView!
    @IBOutlet weak var ageTxtField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var imagePicker : UIImagePickerController!
    let rockMusicien = ["Guitariste", "Batteur"]
    let jazzMusicien = ["Contre-Bassiste"]
    let hiphopMusicien = ["Break-Dance"]
    let sections = ["Rock", "Jazz", "Hip-Hop"]
    var musicStyle = [String]()
    var gender : String?
    var image = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userDescription.delegate = self
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
        guard let imageData = self.defaultProfileImg.image?.jpegData(compressionQuality: 0.4) else {
            return
        }
        let storageRef = Storage.storage().reference(forURL: "gs://musicap-aec73.appspot.com/")
        let storageProfileRef = storageRef.child("profile").child(Auth.auth().currentUser!.uid)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        storageProfileRef.putData(imageData, metadata: metadata) { (storageMetaData, error) in
            if error != nil {
                print(error!)
                return
            }
            storageProfileRef.downloadURL { (url, error) in
                if let metaImgUrl = url?.absoluteString{
                    let userImg = ["profileImgURL": metaImgUrl]
                    DataServices.instance.createDBUsers(unikID: Auth.auth().currentUser!.uid, userData: userImg)
                }
            }
        }
    }
    
    @IBAction func SCchanged(_ sender: Any) {
        if(genderSegmentedControl.selectedSegmentIndex == 0){
            let male = "Homme"
            gender = male
        } else if(genderSegmentedControl.selectedSegmentIndex == 2) {
            let female = "Femme"
            gender = female
        }
    }
    
    @IBAction func createAccPressed(_ sender: Any) {
        
        let stringMusicStyle = musicStyle.joined(separator: "_")
        
        if stringMusicStyle == "" {
            displayAlertMessage(title: "Oups !", msg: "Sélectionnez un style musical que vous pratiquez")
        } else {
        if (genderSegmentedControl.selectedSegmentIndex == 1) {
            displayAlertMessage(title: "Oups !", msg: "Veuillez-nous indiquer si vous êtes un homme ou une femme")
        } else {
        if emailTxtField.text != nil && passwordTxtField.text != nil && nameTxtField.text != nil && ageTxtField.text != nil && userDescription.text != nil{
            AuthService.instance.registerUser(withEmail: self.emailTxtField.text!, andPassword: passwordTxtField.text!, gender: gender!, name: self.nameTxtField.text!, age: self.ageTxtField.text!, musicStyle: stringMusicStyle, userDescription: self.userDescription.text!, filterParams: "\(gender!)_\(stringMusicStyle)") { (success, registrationError)
                in
                if success{
                    self.uploadPhoto()
                    print("Succes registration")
                    self.performSegue(withIdentifier: "showLogin", sender: self)
                } else {
                    self.displayAlertMessage(title: "Oups !",msg: "Veuillez remplir tous les champs obligatoires")
                    print(String(describing: registrationError?.localizedDescription))
                    }
                }
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

extension CreateAccVC : UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray{
            textView.text = nil
            textView.textColor = UIColor.white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty{
            textView.text = "Une brève description de vous, ce que vous aimez... de quel instrument vous jouez... vos disponibilités..."
            textView.textColor = UIColor.lightGray
        }
    }
}


