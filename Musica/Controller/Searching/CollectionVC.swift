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
        getUsers()
        let seconds = 2.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds){
            print(self.queryUser)
        }
    }
        
    private var dispatchQueue: DispatchQueue = DispatchQueue(label: "CollectionView")
    var nameIndexpath = String()
    var imgIndexpath = String()
    var descriptionIndexpath = String()
    var musicStyleIndexpath = [String]()
    var musicienArray : [DataSnapshot] = []
    var queryUser : [DataSnapshot]?

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func settingsBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "showParameter", sender: self)
    }
    
    @IBAction func searchBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "searchingSegue", sender: self)
    }
    
    func getUsers(){
        let rootRef = Database.database().reference()
        let query = rootRef.child("users")
        query.observeSingleEvent(of: .value) { (snapshot) in
            self.musicienArray = snapshot.children.allObjects as! [DataSnapshot]
            self.collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if queryUser != nil {
            return queryUser?.count ?? 0
        } else {
            return musicienArray.count
        }
    }
            
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "musicaCell", for: indexPath) as! CollectionCell
        let musicien = musicienArray[indexPath.row].value as? NSDictionary
        if let queryMusicien = queryUser?[indexPath.row].value as? NSDictionary {
            cell.userNameLbl.text = queryMusicien["name"] as? String
            dispatchQueue.async {
                let arrayUrl = URL(string: queryMusicien["profileImgURL"] as! String)
                let arrayData = try! Data(contentsOf: arrayUrl!)
                let img = UIImage(data: arrayData)
                
                DispatchQueue.main.async {
                    cell.profilUsersImage.image = img!
                } 
            }
        }
        else {
        cell.userNameLbl.text = musicien?["name"] as? String
        dispatchQueue.async {
            let arrayUrl = URL(string: musicien?["profileImgURL"] as! String)!
            let arrayData = try! Data(contentsOf: arrayUrl)
            let img = UIImage(data: arrayData)
            
            DispatchQueue.main.async {
                cell.profilUsersImage.image = img!
            }
        }
    }
        return cell
}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailUserVC{
            destination.name = nameIndexpath
            destination.stringImg = imgIndexpath
            destination.userDescription = descriptionIndexpath
            destination.userStyle = musicStyleIndexpath
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let musicienParams = musicienArray[indexPath.row].value as? NSDictionary
        if let queryMusicien = queryUser?[indexPath.row].value as? NSDictionary{
            nameIndexpath = (queryMusicien["name"] as? String)!
            imgIndexpath = (queryMusicien["profileImgURL"] as? String)!
            descriptionIndexpath = (queryMusicien["description"] as? String)!
            musicStyleIndexpath = (queryMusicien["musicStyle"] as? [String])!
        } else {
        nameIndexpath = (musicienParams?["name"] as? String)!
        imgIndexpath = (musicienParams?["profileImgURL"] as? String)!
        descriptionIndexpath = (musicienParams?["description"] as? String)!
        musicStyleIndexpath = (musicienParams?["musicStyle"] as? [String])!
    }
        performSegue(withIdentifier: "showDetail", sender: self)
    }
}
