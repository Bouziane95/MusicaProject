//
//  ParamsVC.swift
//  Musica
//
//  Created by Bouziane Bey on 21/11/2019.
//  Copyright © 2019 Bouziane Bey. All rights reserved.
//

import Foundation
import UIKit

class ParamsVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var genderArray : Array = ["Hommes", "Femmes", "Pas d'importance"]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBAction func closeBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func chooseMusicStyle(_ sender: Any) {
        let chooseMusicStyleVC = storyboard?.instantiateViewController(withIdentifier: "ChooseMusicienVC")
        present(chooseMusicStyleVC!, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genderArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "genderCell", for: indexPath)
        cell.textLabel?.text = genderArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.checkmark {
                  tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
              } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
              }
              tableView.deselectRow(at: indexPath, animated: true)
          }
    }

