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
        getImgUser()
        getNamesUser()
        getDescriptionUser()
    }
    
    private var dispatchQueue: DispatchQueue = DispatchQueue(label: "CollectionView")
    var arrayName = [String]()
    var timeStamp = [Int]()
    var arrayDescription = [String]()
    var arrayProfilImage = [String]()
    var nameIndexpath = String()
    var imgIndexpath = String()
    var descriptionIndexpath = String()
   
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func settingsBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "showParameter", sender: self)
    }
    
    @IBAction func searchBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "searchingSegue", sender: self)
    }
    
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
           let query = rootRef.child("users").queryOrdered(byChild: "profileImgURL")
           query.observeSingleEvent(of: .value) { (snapshot) in
               let nameArray = snapshot.children.allObjects as! [DataSnapshot]
               for child in nameArray{
                   let value = child.value as? NSDictionary
                   let child = value?["profileImgURL"] as? String
                   self.arrayProfilImage.append(child!)
               }
               self.collectionView.reloadData()
           }
       }
    
    func getDescriptionUser(){
           let rootRef = Database.database().reference()
           let query = rootRef.child("users").queryOrdered(byChild: "description")
           query.observeSingleEvent(of: .value) { (snapshot) in
               let description = snapshot.children.allObjects as! [DataSnapshot]
               for child in description{
                   let value = child.value as? NSDictionary
                   let child = value?["description"] as? String
                   self.arrayDescription.append(child!)
               }
               self.collectionView.reloadData()
           }
       }
    
//    func sortResult(){
//        let ref = Database.database().reference().child("users")
//        _ = ref.queryOrdered(byChild: "timeStamp").queryLimited(toLast: 50).observe(.value) { (snapshot) in
//            let timeStamp = snapshot.children.allObjects as! [DataSnapshot]
//            for child in timeStamp{
//                let value = child.value as? NSDictionary
//                let child = value?["timeStamp"] as? Int
//                self.timeStamp.append(child!)
//                self.timeStamp.sort(by: {$0 > $1})
//            }
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayName.count
    }
            
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "musicaCell", for: indexPath) as! CollectionCell
        cell.userNameLbl.text = arrayName[indexPath.row]
        
        DispatchQueue.main.async {
            let arrayUrl = URL(string: self.arrayProfilImage[indexPath.row])!
            let arrayData = try! Data(contentsOf: arrayUrl)
            let img = UIImage(data: arrayData)
            cell.profilUsersImage.image = img!
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailUserVC{
            destination.name = nameIndexpath
            destination.stringImg = imgIndexpath
            destination.userDescription = descriptionIndexpath
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        imgIndexpath = arrayProfilImage[indexPath.row]
        nameIndexpath = arrayName[indexPath.row]
        descriptionIndexpath = arrayDescription[indexPath.row]
        performSegue(withIdentifier: "showDetail", sender: self)
    }
}
