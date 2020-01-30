//
//  ChooseMusicStyleVC.swift
//  Musica
//
//  Created by Bouziane Bey on 21/11/2019.
//  Copyright © 2019 Bouziane Bey. All rights reserved.
//

import UIKit

class ChooseMusicStyleVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func rockBtnPressed(_ sender: Any) {
        let chooseMusicienVC = storyboard?.instantiateViewController(withIdentifier: "ChooseMusicienVC")
        present(chooseMusicienVC!, animated: true, completion: nil)
    }
    
    @IBAction func jazzBtnPressed(_ sender: Any) {
    }
    
    @IBAction func hiphopBtnPressed(_ sender: Any) {
    }
    
    @IBAction func technoBtnPressed(_ sender: Any) {
    }
    
    @IBAction func salsaBtnPressed(_ sender: Any) {
    }
    
    @IBAction func classicBtnPressed(_ sender: Any) {
    }
    
}
