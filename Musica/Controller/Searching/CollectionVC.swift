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
    }
    var imageReference : StorageReference{
           return Storage.storage().reference().child("imgProfiles")
       }
    var arrayName = [String]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func settingsBtnPressed(_ sender: Any) {
        let profilVC = storyboard?.instantiateViewController(withIdentifier: "ProfileVC")
        present(profilVC!, animated: true, completion: nil)
    }
    
    @IBAction func searchBtnPressed(_ sender: Any) {
        let searchingVC = storyboard?.instantiateViewController(withIdentifier: "SearchingVC")
        present(searchingVC!, animated: true, completion: nil)
    }
    
    
    
    let users = ["Paul McCartney", "David Gilmour", "James Hetfield", "Phil Rudd", "Mick Jagger", "Jimi Hendrix", "Elvis Presley", "Michael Jackson", "Bob Marley", "Stevie Wonder", "James Brown", "Aretha Franklin"]
    
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "musicaCell", for: indexPath) as! CollectionCell
        
        let roofRef = Database.database().reference()
        let query = roofRef.child("users").queryOrdered(byChild: "name")
        query.observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot]{
                let value = child.value as? NSDictionary
                let name = value?["name"] as? String ?? ""
                self.arrayName.append(name)
                cell.userNameLbl.text = self.arrayName[indexPath.row]
            }
        }
        
//        let uid = Auth.auth().currentUser?.uid
//        let downloadImageRef = imageReference.child("\(uid)")
//        let downloadTask = downloadImageRef.getData(maxSize: 1024 * 1024 * 12) { (data, error) in
//            if let data = data {
//                let image = UIImage(data: data)
//                cell.profilUsersImage.image = image
//            }
//            print(error ?? "NO ERROR")
//        }
//        downloadTask.observe(.progress) { (snapshot) in
//            print(snapshot.progress ?? "NO PROGRESS NOW")
//        }
//        downloadTask.resume()
        
        cell.profilUsersImage.image = userImage[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailUserVC") as? DetailUserVC
        detailVC?.name = users[indexPath.row]
        detailVC?.musicStyle = musicianStyle[indexPath.row]
        self.navigationController?.pushViewController(detailVC!, animated: true)
    }
}