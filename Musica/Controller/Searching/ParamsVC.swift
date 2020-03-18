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
    
    var genderArray : Array = ["Homme", "Femme", "N.C."]
    let rockMusicien = ["Guitariste", "Batteur"]
    let jazzMusicien = ["Contre-Bassiste"]
    let hiphopMusicien = ["Break-Dance"]
    let sections = ["Rock", "Jazz", "Hip-Hop"]
    var userQuery : [DataSnapshot] = []
    var gender : String?
    var style : [String]? = []
    
    @IBOutlet weak var genderTableView: UITableView!
    @IBOutlet weak var musicStyleTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navTitle()
        genderTableView.dataSource = self
        genderTableView.delegate = self
        musicStyleTableView.delegate = self
        musicStyleTableView.dataSource = self
    }
    
    func navTitle(){
        let attributes = [NSAttributedString.Key.font: UIFont(name: "Avenir", size: 26)!]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        self.navigationItem.title = "Ma recherche"
    }
    
    @IBAction func closeBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CollectionVC{
            if gender != nil && style != [] {
                guard let stringStyle = style?.joined(separator: "_") else {return}
                let rootRef = Database.database().reference()
                let query = rootRef.child("users").queryOrdered(byChild: "filterParameters").queryEqual(toValue: "\(gender!)_\(stringStyle)")
                query.observeSingleEvent(of: .value) { (snapshot) in
                    self.userQuery = snapshot.children.allObjects as! [DataSnapshot]
                    destination.queryUser = self.userQuery
                }
            } else if gender != nil && style == [] {
                let rootRef = Database.database().reference()
                let query = rootRef.child("users").queryOrdered(byChild: "gender").queryEqual(toValue: "\(gender!)")
                query.observeSingleEvent(of: .value) { (snapshot) in
                    self.userQuery = snapshot.children.allObjects as! [DataSnapshot]
                    destination.queryUser = self.userQuery
                }
            } else if gender == nil && style != []{
                guard let stringStyle = style?.joined(separator: "_") else {return}
                print(stringStyle)
                let rootRef = Database.database().reference()
                let query = rootRef.child("users").queryOrdered(byChild: "musicStyle").queryEqual(toValue: "\(stringStyle)")
                query.observeSingleEvent(of: .value) { (snapshot) in
                    self.userQuery = snapshot.children.allObjects as! [DataSnapshot]
                    destination.queryUser = self.userQuery
                }
            }
        }
}
    
    @IBAction func searchBtn(_ sender: Any) {
        performSegue(withIdentifier: "backToCollectionVC", sender: self)
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
        let section = sections[section]
        switch tableView {
        case musicStyleTableView:
            return section
        default:
            break
        }
        return "A vous de choisir"
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView{
        case genderTableView:
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            gender = genderArray[indexPath.row]
        case musicStyleTableView:
            switch indexPath.section {
            case 0:
                if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.checkmark{
                    tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
                    style?.remove(at: indexPath.row)
                    print(style!)
                } else {
                    tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
                    style?.append(rockMusicien[indexPath.row])
                    print(style!)
                }
            case 1:
                if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.checkmark{
                    tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
                    style?.remove(at: indexPath.row)
                    print(style!)
                } else {
                    tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
                    style?.append(jazzMusicien[indexPath.row])
                    print(style!)
                }
            case 2:
                if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.checkmark{
                    tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
                    style?.remove(at: indexPath.row)
                    print(style!)
                } else {
                    tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
                    style?.append(hiphopMusicien[indexPath.row])
                    print(style!)
                }
            default:
                break
            }
            
            tableView.deselectRow(at: indexPath, animated: true)
        default:
            break
        }
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        switch tableView{
        case genderTableView:
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        default:
            break
        }
    }
}




