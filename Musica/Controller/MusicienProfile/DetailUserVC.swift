//
//  DetailUserVC.swift
//  Musica
//
//  Created by Bouziane Bey on 21/11/2019.
//  Copyright © 2019 Bouziane Bey. All rights reserved.
//

import UIKit

class DetailUserVC: UIViewController {
    
    var musicStyle = String()
    var name = String()
    var userDescription = String()
    var stringImg = String()
    private var dispatchQueue: DispatchQueue = DispatchQueue(label: "imageDetail")
  
    @IBOutlet weak var descriptionUser: UITextView!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var nameUser: UILabel!
    @IBOutlet weak var musicStyleUser: UILabel!
    @IBOutlet weak var mySoundsBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameUser.text = name
        musicStyleUser.text = musicStyle
        descriptionUser.text = userDescription
        musicStyleUser.text = musicStyle
        dispatchQueue.async {
            self.showUsersImg()
        }
    }
    
    func showUsersImg(){
        print(stringImg)
        let imageUrl = URL(string: stringImg)
        let imagedata = try! Data(contentsOf: imageUrl!)
        let imageProfil = UIImage(data: imagedata)
        DispatchQueue.main.async {
            self.imageProfile.image = imageProfil
        }
    }
    
    @IBAction func sendMsgBtnPressed(_ sender: Any) {
        let ChatVC = storyboard?.instantiateViewController(withIdentifier: "ChatVC")
        present(ChatVC!, animated: true, completion: nil)
    }
    

}
