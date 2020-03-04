//
//  ParamsVC.swift
//  Musica
//
//  Created by Bouziane Bey on 21/11/2019.
//  Copyright © 2019 Bouziane Bey. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ParamsVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var genderArray : Array = ["Hommes", "Femmes", "Pas d'importance"]
    let rockMusicien = ["Guitariste", "Batteur"]
    let jazzMusicien = ["Contre-Bassiste"]
    let hiphopMusicien = ["Break-Dance"]
    let sections = ["Rock", "Jazz", "Hip-Hop"]
    var musicStyle = [String]()
    
    @IBOutlet weak var genderTableView: UITableView!
    @IBOutlet weak var musicStyleTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        genderTableView.dataSource = self
        genderTableView.delegate = self
        musicStyleTableView.delegate = self
        musicStyleTableView.dataSource = self
    }
    
    @IBAction func closeBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func searchingGender(){
        let ref = Database.database().reference().child("users")
        let query = ref.queryOrdered(byChild: "sex").queryEqual(toValue: "0")
        query.observeSingleEvent(of: .value) { (snapshot) in
            let gender = snapshot.children.allObjects as! [DataSnapshot]
            for child in gender{
                let value = child.value as? NSDictionary
                let child = value?["sex"] as? [String]
                print("i'm here")
                print(child!)
            }
        }
    }
    
    
    @IBAction func searchBtn(_ sender: Any) {
        //Filtrer les resultats de la recherche sur firebase
        searchingGender()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numberSection = 0
        if tableView == musicStyleTableView{
            numberSection = 3
        } else if tableView == genderTableView{
            numberSection = 1
        }
        return numberSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRow = 1
        switch tableView {
        case genderTableView:
            numberOfRow = genderArray.count
        case musicStyleTableView:
            switch section {
            case 0:
                numberOfRow = rockMusicien.count
            case 1:
                numberOfRow = jazzMusicien.count
            case 2:
                numberOfRow = hiphopMusicien.count
            default:
                return 0
            }
        default:
            print("Problem with table view")
        }
        return numberOfRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        switch tableView {
        case genderTableView:
            cell = tableView.dequeueReusableCell(withIdentifier: "genderCell", for: indexPath)
            cell.textLabel?.text = genderArray[indexPath.row]
            cell.textLabel?.font = UIFont(name: "Avenir Next", size: 17)
            cell.textLabel?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        case musicStyleTableView:
            cell = tableView.dequeueReusableCell(withIdentifier: "musicStyleCell", for: indexPath)
            switch indexPath.section {
            case 0:
                cell.textLabel?.text = rockMusicien[indexPath.row]
                break
            case 1:
                cell.textLabel?.text = jazzMusicien[indexPath.row]
                break
            case 2:
                cell.textLabel?.text = hiphopMusicien[indexPath.row]
                break
            default:
                break
            }
            cell.textLabel?.font = UIFont(name: "Avenir Next", size: 17)
            cell.textLabel?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        default:
            print("Error")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let lasection = sections[section]
        switch tableView {
        case musicStyleTableView:
            return lasection
        default:
            break
        }
        return "A vous de choisir"
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

