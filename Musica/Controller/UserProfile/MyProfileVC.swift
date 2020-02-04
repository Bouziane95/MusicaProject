//
//  MyProfileVC.swift
//  Musica
//
//  Created by Bouziane Bey on 19/11/2019.
//  Copyright © 2019 Bouziane Bey. All rights reserved.
//

import UIKit
import Firebase
import Photos


class MyProfileVC: UIViewController {

    @IBOutlet weak var emailAcc: UILabel!
    @IBOutlet weak var musicStyle: UILabel!
    @IBOutlet weak var ageAcc: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var nameAcc: UILabel!
    
    var imageReference : StorageReference{
        return Storage.storage().reference().child("imgProfiles")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.emailAcc.text = Auth.auth().currentUser?.email
        downloadName()
        downloadAge()
        //downloadPhoto()
    }
    
    func downloadName(){
        let roofRef = Database.database().reference()
        let query = roofRef.child("users").queryOrdered(byChild: "name")
        query.observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot]{
                let value = child.value as? NSDictionary
                let name = value?["name"] as? String ?? ""
                print(name)
                self.nameAcc.text = name
            }
        }
    }
    
    func downloadAge(){
        let roofRef = Database.database().reference()
        let query = roofRef.child("users").queryOrdered(byChild: "age")
        query.observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot]{
                let value = child.value as? NSDictionary
                let age = value?["age"] as? String ?? ""
                print(age)
                self.ageAcc.text = age
            }
        }
    }
    
    func downloadPhoto(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let downloadImageRef = imageReference.child("\(uid)")
        let downloadTask = downloadImageRef.getData(maxSize: 1024 * 1024 * 12) { (data, error) in
            if let data = data {
                let image = UIImage(data: data)
                self.profileImg.image = image
            }
            print(error ?? "NO ERROR")
        }
        downloadTask.observe(.progress) { (snapshot) in
            print(snapshot.progress ?? "NO PROGRESS NOW")
        }
        downloadTask.resume()
    }
    
    
    @IBAction func signOutBtnPressed(_ sender: Any) {
        let logoutPopUp = UIAlertController(title: "Déconnexion", message: "êtes-vous sûr de vouloir vous déconnecter ?", preferredStyle: .actionSheet)
        let cancelLogout = UIAlertAction(title: "Annuler", style: .cancel, handler: nil)
        
        let logoutAction = UIAlertAction(title: "Déconnexion", style: .destructive) { (buttonTapped) in
            do{
                try Auth.auth().signOut()
                let authVC = self.storyboard?.instantiateViewController(withIdentifier: "AuthVC") as? AuthVC
                self.present(authVC!, animated: true, completion: nil)
            } catch {
                print(error)
            }
        }
        logoutPopUp.addAction(logoutAction)
        logoutPopUp.addAction(cancelLogout)
        present(logoutPopUp, animated: true, completion: nil)
    }
    
    
    @IBAction func btnDismissedPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
