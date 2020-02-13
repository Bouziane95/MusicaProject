//
//  DetailUserVC.swift
//  Musica
//
//  Created by Bouziane Bey on 21/11/2019.
//  Copyright © 2019 Bouziane Bey. All rights reserved.
//

import UIKit

class DetailUserVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        nameUser.text = name
        //imageProfile.image = UIImage(named: name)
        //musicStyleUser.text = musicStyle
    }
    
    var name = ""
    var musicStyle = ""
    
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var nameUser: UILabel!
    @IBOutlet weak var musicStyleUser: UILabel!
    @IBOutlet weak var mySoundsBtn: UIButton!
    
   
    @IBAction func sendMsgBtnPressed(_ sender: Any) {
        let ChatVC = storyboard?.instantiateViewController(withIdentifier: "ChatVC")
        present(ChatVC!, animated: true, completion: nil)
    }

}
