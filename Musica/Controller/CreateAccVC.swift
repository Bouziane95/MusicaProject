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

class CreateAccVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    @IBOutlet weak var ageTxtField: UITextField!
    @IBOutlet weak var defaultProfileImg: UIImageView!
    @IBOutlet weak var importProfilImg: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyBoardWhenTappedAround()
    }
    
    func hideKeyBoardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreateAccVC.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    
    @IBAction func createAccPressed(_ sender: Any) {
        progressBar.isHidden = true
        if emailTxtField.text != nil && passwordTxtField.text != nil && nameTxtField.text != nil{
            let randomID = UUID.init().uuidString
            let uploadRef = Storage.storage().reference(withPath: "imgProfiles/\(randomID).jpg")
            guard let imageData = defaultProfileImg.image?.jpegData(compressionQuality: 0.75) else {return}
            let uploadMetaData = StorageMetadata.init()
            uploadMetaData.contentType = "image/jpeg"
            let taskReference = uploadRef.putData(imageData, metadata: uploadMetaData) { (dowloadMetaData, error) in
                if let error = error{
                    print("\(error.localizedDescription)")
                    return
                }
                print("\(dowloadMetaData)")
            }
            taskReference.observe(.progress) { [weak self](snapshot) in
                guard let progressThere = snapshot.progress?.fractionCompleted else {return}
                self?.progressBar.progress = Float(progressThere)
                
            }
            
            AuthService.instance.registerUser(withEmail: self.emailTxtField.text!, andPassword: passwordTxtField.text!) { (success, registrationError) in
                if success{
                    print("Succes registration")
                    let LoginVc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC")
                    self.present(LoginVc!, animated: true, completion: nil)
                } else {
                    print(String(describing: registrationError?.localizedDescription))
                }
            }
        }
    }
    
    func presentPhotoPickerController(){
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.allowsEditing = true
        self.present(myPickerController, animated: true)
    }
    
    func libraryAccessRestricted(){
        let alert = UIAlertController(title: "Photo library access restricted", message: "Photo Library is rectricted and cannot be accessed", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
    func restrictions(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            PHPhotoLibrary.requestAuthorization { (status) in
                switch status{
                case .authorized :
                    self.presentPhotoPickerController()
                    
                case .notDetermined :
                    self.presentPhotoPickerController()
                    
                case .restricted :
                    self.libraryAccessRestricted()
                    
                case .denied :
                    let alert = UIAlertController(title: "Photo Library access denied", message: "Previously denied, please change your settings if you want to change this", preferredStyle: .alert)
                    let goToSettingsAction = UIAlertAction(title: "Go to settings", style: .default) { (action) in
                        DispatchQueue.main.async {
                            let url = URL(string: UIApplication.openSettingsURLString)!
                            UIApplication.shared.open(url, options: [:])
                        }
                    }
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                    alert.addAction(goToSettingsAction)
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            defaultProfileImg.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func importProfilPic(_ sender: Any) {
        restrictions()
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    


}
