//
//  DetailUserVC.swift
//  Musica
//
//  Created by Bouziane Bey on 21/11/2019.
//  Copyright © 2019 Bouziane Bey. All rights reserved.
//

import UIKit

class DetailUserVC: UIViewController {
    
    var userStyle = String()
    var id = String()
    var name = String()
    var age = String()
    var userDescription = String()
    var stringImg = String()
    private var dispatchQueue: DispatchQueue = DispatchQueue(label: "imageDetail")
  
    @IBOutlet weak var descriptionUser: UITextView!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var nameUser: UILabel!
    @IBOutlet weak var musicStyleUser: UILabel!
    @IBOutlet weak var ageUser: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameUser.text = name
        ageUser.text = age
        let occurencesUserStyle = userStyle.replacingOccurrences(of: "_", with: ", ")
        musicStyleUser.text = occurencesUserStyle
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination  = segue.destination as? ChatVC{
            destination.idIndexpath = id
            destination.imgFromChatTV = stringImg
        }
        
    }
    
    @IBAction func sendMsgBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "showChat", sender: self)
    }
    

}
