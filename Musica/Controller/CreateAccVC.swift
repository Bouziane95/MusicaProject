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
    @IBOutlet weak var agePickerView: UIPickerView!
    @IBOutlet weak var defaultProfileImg: UIImageView!
    
    var imagePicker : UIImagePickerController!
    var imageReference : StorageReference{
        return Storage.storage().reference().child("imgProfiles")
    }
    var pickerData : [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loopPickerData()
        self.agePickerView.delegate = self
        self.agePickerView.dataSource = self
        hideKeyBoardWhenTappedAround()
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        defaultProfileImg.isUserInteractionEnabled = true
        defaultProfileImg.addGestureRecognizer(imageTap)
        defaultProfileImg.layer.cornerRadius = defaultProfileImg.bounds.height / 2
        defaultProfileImg.clipsToBounds = true
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
    }
    
    func loopPickerData(){
    for i in 18...99{
        let b = String(i)
        pickerData.append(b)
        //print(pickerData)
        }
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
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let storageRef = imageReference.child("\(uid)")
        
        guard let image = defaultProfileImg.image else {return}
        guard let imageData = image.jpegData(compressionQuality: 1) else {return}
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        let uploadTask = storageRef.putData(imageData, metadata: metaData) { (metadata, error) in
            print(metadata ?? "NO METADATA")
            print(error ?? "NO ERROR")
        }
        uploadTask.observe(.progress) { (snapshot) in
            print(snapshot.progress ?? "NO MORE PROGRESS")
        }
        uploadTask.resume()
    }
    
    @IBAction func createAccPressed(_ sender: Any) {
        if emailTxtField.text != nil && passwordTxtField.text != nil && nameTxtField.text != nil {
            AuthService.instance.registerUser(withEmail: self.emailTxtField.text!, andPassword: passwordTxtField.text!, name: self.nameTxtField.text!) { (success, registrationError)
                in
                if success{
                    self.uploadPhoto()
                    print("Succes registration")
                    let LoginVc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC")
                    self.present(LoginVc!, animated: true, completion: nil)
                } else {
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

extension CreateAccVC: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: pickerData[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
}

