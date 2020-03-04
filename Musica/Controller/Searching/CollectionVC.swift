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
    }
    
    private var dispatchQueue: DispatchQueue = DispatchQueue(label: "CollectionView")
    var arrayName = [String]()
    var timeStamp = [Int]()
    var arrayDescription = [String]()
    var arrayProfilImage = [String]()
    var nameIndexpath = String()
    var imgIndexpath = String()
    var descriptionIndexpath = String()
    var musicienArray : [DataSnapshot] = []
   
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
        return musicienArray.count
    }
            
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "musicaCell", for: indexPath) as! CollectionCell
        let musicien = musicienArray[indexPath.row].value as? NSDictionary
        
        cell.userNameLbl.text = musicien?["name"] as? String
        DispatchQueue.main.async {
            let arrayUrl = URL(string: musicien?["profileImgURL"] as! String)!
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
        let musicienParams = musicienArray[indexPath.row].value as? NSDictionary
        nameIndexpath = (musicienParams?["name"] as? String)!
        imgIndexpath = (musicienParams?["profileImgURL"] as? String)!
        descriptionIndexpath = (musicienParams?["description"] as? String)!
        performSegue(withIdentifier: "showDetail", sender: self)
    }
}
