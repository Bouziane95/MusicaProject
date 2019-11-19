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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.emailAcc.text = Auth.auth().currentUser?.email
        fetchImageProfil()
    }
    
    func fetchImageProfil(){
        let storageRef = Storage.storage().reference(withPath: "imgProfiles/153E93A1-9A60-4CC7-B8CA-D4EA4BB170FE.jpg")
        storageRef.getData(maxSize: 4 * 1024 * 1024) { [weak self] (data, error) in
            if let error = error {
                print("\(error.localizedDescription)")
                return
            }
            if let data = data{
                self?.profileImg.image = UIImage(data: data)
            }
        }
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
