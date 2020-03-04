//
//  DetailUserVC.swift
//  Musica
//
//  Created by Bouziane Bey on 21/11/2019.
//  Copyright © 2019 Bouziane Bey. All rights reserved.
//

import UIKit

class DetailUserVC: UIViewController {
    
    var userStyle = [String]()
    var name = String()
    var userDescription = String()
    var stringImg = String()
    private var dispatchQueue: DispatchQueue = DispatchQueue(label: "imageDetail")
  
    @IBOutlet weak var descriptionUser: UITextView!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var nameUser: UILabel!
    @IBOutlet weak var musicStyleUser: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameUser.text = name
        let stringUserStyle = userStyle.joined(separator: ", ")
        musicStyleUser.text = stringUserStyle
        descriptionUser.text = userDescription
        dispatchQueue.async {
            self.showUsersImg()
        }
    }
    
    func showUsersImg(){
        let imageUrl = URL(string: self.stringImg)
        let imagedata = try! Data(contentsOf: imageUrl!)
        let imageProfil = UIImage(data: imagedata)
        DispatchQueue.main.async {
            self.imageProfile.image = imageProfil
        }
    }
    
    @IBAction func sendMsgBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "showChat", sender: self)
    }
    

}
