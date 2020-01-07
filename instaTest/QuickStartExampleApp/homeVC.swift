//
//  homeVC.swift
//  QuickStartExampleApp
//
//  Created by Bo Zhang on 1/6/20.
//  Copyright © 2020 Back4App. All rights reserved.
//

import UIKit
import Parse

class homeVC: UICollectionViewController {

    //refresher variable
    var refresher : UIRefreshControl!
    
    //size of page
    var page : Int = 10
    
    var uuidArray = [String]()
    var picArray = [PFFileObject]()
    
    //default function
    override func viewDidLoad() {
        super.viewDidLoad()
       //background color
        collectionView.backgroundColor = .white
        
        //header
        self.navigationItem.title = PFUser.current()?.username?.uppercased()
        
        //pull to refresh
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: "refresh", for: UIControl.Event.valueChanged)
        collectionView.addSubview(refresher)
        
        //load post
        loadPosts()
    }
    
    //refreshing func
    func refresh() {
        
        //reload data info
        collectionView.reloadData()
        
        //stop refresher animating
        //refresher.endRefreshing()
    }
    
    //load posts func
    func loadPosts(){
        
        let query = PFQuery(className: "post")
        query.whereKey("username", equalTo: PFUser.current()?.username!)
        query.limit = page
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if error == nil {
                
                //clean up
                self.uuidArray.removeAll(keepingCapacity: false)
                self.picArray.removeAll(keepingCapacity: false)
                
                for object in objects! {
                    
                    self.uuidArray.append(object.object(forKey: "uuid") as! String)
                    self.picArray.append((object.object(forKey: "pic") as! PFFileObject))
                    
                }
                self.collectionView.reloadData()
                
                
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
         return picArray.count
     }
     
     
     override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         
        // Configure the cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! pictureCell
       
        //get pic from picArray
        picArray[indexPath.row].getDataInBackground { (data, error) in
            if error == nil {
                cell.picImg.image = UIImage(data: data!)
                
            } else {
                print(error?.localizedDescription)
            }
        }
         return cell
     }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        //define header
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! headerView
        header.fullnameLbl.text = (PFUser.current()?.object(forKey: "fullname") as? String)?.uppercased()
        header.webTxt.text = PFUser.current()?.object(forKey: "web") as? String
        header.webTxt.sizeToFit()
        
        header.bioLbl.text = PFUser.current()?.object(forKey: "bio") as? String
        header.bioLbl.sizeToFit()
        
        header.button.setTitle("Edit Profile", for: UIControl.State.normal)
        
        let avaQuery = PFUser.current()?.object(forKey: "ava") as! PFFileObject
        
        avaQuery.getDataInBackground { (data, error) in
            //let data = NSData(data: imageData!)
            header.avaImg.image = UIImage(data: data!)
            
        }
        
        return header
        
    }


 
     

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
