//
//  guestVC2.swift
//  QuickStartExampleApp
//
//  Created by Bo Zhang on 1/19/20.
//  Copyright © 2020 Back4App. All rights reserved.
//

import UIKit
import Parse

var guestname = [String]()

class guestVC2: UICollectionViewController {
    
    var page : Int = 10
    
    //array to hold data from server
    var uuidArray = [String]()
    var picArray = [PFFileObject]()
       
    override func viewDidLoad() {
        super.viewDidLoad()

        //top title
        self.navigationItem.title = guestname.last
       

        loadPosts()
    
        
    }

    //posts loading function
    func loadPosts() {
        
        print("loading.. guest ")
        let query = PFQuery(className: "post")
        query.whereKey("username", equalTo: guestname.last!)
        query.limit = page
        query.findObjectsInBackground { (objects:[PFObject]?, error:Error?) in
            
            if error == nil{
                for object in objects! {
                
                    //hold found info in arrays
                    self.uuidArray.append(object.value(forKey: "uuid") as! String)
                    self.picArray.append(object.value(forKey: "pic") as! PFFileObject)
                    print("guest object: \(object.value(forKey: "uuid"))")
                }
                
                self.collectionView.reloadData()
                
            }else{
                print(error?.localizedDescription)
            }
            
        }
    }

    //number of items
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return picArray.count
    }

    //data in each cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //connect data from array to pictureCell class
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! pictureCell
        picArray[indexPath.row].getDataInBackground { (data:Data?, error:Error?) in
            if error == nil{
                cell.picImg.image = UIImage(data: data!)
                
            }else {
                print(error?.localizedDescription)
            }
        }
        
        return cell
    }

   
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //go post
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("clicked the post from guestVC")
        //add post uuid to postuuid var
        postuuid.append(uuidArray[indexPath.row])
        
        //navigate to post view controller
        let post = self.storyboard?.instantiateViewController(identifier: "postVC") as! postVC
        self.navigationController?.pushViewController(post, animated: true)
        
    }
 

}
