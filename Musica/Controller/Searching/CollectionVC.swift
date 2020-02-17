//
//  CollectionVC.swift
//  Musica
//
//  Created by Bouziane Bey on 21/11/2019.
//  Copyright © 2019 Bouziane Bey. All rights reserved.
//

import UIKit
import Firebase

class CollectionVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
   
    

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        getNamesUser()
        getImgUser()
        //getMusicStyleUser()
        getDescriptionUser()
    }
    
    var arrayName = [String]()
    var arrayProfilImage = [String]()
    var musicStyleArray = [String]()
    var arrayDescription = [String]()
    var imageReference : DatabaseReference{
           return Database.database().reference().child("profileImg")
       }
    var nameIndexpath = String()
    var descriptionIndexpath = String()
    var musicStyleIndexpath = String()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func settingsBtnPressed(_ sender: Any) {
        let profilVC = storyboard?.instantiateViewController(withIdentifier: "ProfileVC")
        present(profilVC!, animated: true, completion: nil)
    }
    
    @IBAction func searchBtnPressed(_ sender: Any) {
        let searchingVC = storyboard?.instantiateViewController(withIdentifier: "SearchingVC")
        present(searchingVC!, animated: true, completion: nil)
    }
    
    let userImage: [UIImage] = [
        UIImage(named: "Paul McCartney")!,
        UIImage(named: "David Gilmour")!,
        UIImage(named: "James Hetfield")!,
        UIImage(named: "Phil Rudd")!,
        UIImage(named: "Mick Jagger")!,
        UIImage(named: "Jimi Hendrix")!,
        UIImage(named: "Elvis Presley")!,
        UIImage(named: "Michael Jackson")!,
        UIImage(named: "Bob Marley")!,
        UIImage(named: "Stevie Wonder")!,
        UIImage(named: "James Brown")!,
        UIImage(named: "Aretha Franklin")!,
    ]

    let musicianStyle = ["Guitariste", "Guitariste", "Guitariste", "Batteur", "Guitariste", "Bassiste", "Chanteur", "Chanteur", "Chanteur", "Chanteur", "Chanteur", "Chanteuse"]
    
    func getNamesUser(){
        let rootRef = Database.database().reference()
        let query = rootRef.child("users").queryOrdered(byChild: "name")
        query.observeSingleEvent(of: .value) { (snapshot) in
            let nameArray = snapshot.children.allObjects as! [DataSnapshot]
            for child in nameArray{
                let value = child.value as? NSDictionary
                let child = value?["name"] as? String
                self.arrayName.append(child!)
            }
            self.collectionView.reloadData()
        }
    }
    
    func getImgUser(){
        let rootRef = Database.database().reference()
        let query = rootRef.child("users").queryOrdered(byChild: "profileImg")
        query.observeSingleEvent(of: .value) { (snapshot) in
            let nameArray = snapshot.children.allObjects as! [DataSnapshot]
            for child in nameArray{
                let value = child.value as? NSDictionary
                let child = value?["profileImg"] as? String
                self.arrayProfilImage.append(child!)
            }
            self.collectionView.reloadData()
        }
    }
    
    func getMusicStyleUser(){
        let rootRef = Database.database().reference()
        let query = rootRef.child("users").queryOrdered(byChild: "musicStyle")
        query.observeSingleEvent(of: .value) { (snapshot) in
            let musicStyleArray = snapshot.children.allObjects as! [DataSnapshot]
            for child in musicStyleArray{
                let value = child.value as? NSDictionary
                let child = value?["musicStyle"] as? String
                self.musicStyleArray.append(child!)
            }
            self.collectionView.reloadData()
        }
    }
    
    func getDescriptionUser(){
        let rootRef = Database.database().reference()
        let query = rootRef.child("users").queryOrdered(byChild: "description")
        query.observeSingleEvent(of: .value) { (snapshot) in
            let musicStyleArray = snapshot.children.allObjects as! [DataSnapshot]
            for child in musicStyleArray{
                let value = child.value as? NSDictionary
                let child = value?["description"] as? String
                self.arrayDescription.append(child!)
            }
            self.collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayName.count
    }
            
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "musicaCell", for: indexPath) as! CollectionCell
        cell.userNameLbl.text = arrayName[indexPath.row]
        //cell.profilUsersImage.image = userImage[indexPath.row]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailUserVC{
            destination.name = nameIndexpath
            destination.userDescription = descriptionIndexpath
            destination.musicStyle = musicStyleIndexpath
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        nameIndexpath = arrayName[indexPath.row]
        descriptionIndexpath = arrayDescription[indexPath.row]
        //musicStyleIndexpath = musicStyleArray[indexPath.row]
        performSegue(withIdentifier: "showDetail", sender: self)
    }
}
