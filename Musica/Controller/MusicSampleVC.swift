//
//  MusicSampleVC.swift
//  Musica
//
//  Created by Bouziane Bey on 18/12/2019.
//  Copyright © 2019 Bouziane Bey. All rights reserved.
//

import UIKit

class MusicSampleVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "sampleCell", for: indexPath) as! MusicSampleCell
        cell.titleMusicCell.text = "Sample 1"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       performSegue(withIdentifier: "showSoundVC", sender: self)
    }
    
    
}
