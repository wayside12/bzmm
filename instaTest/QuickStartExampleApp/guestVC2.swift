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
    var postCount: Int32 = 0
   
    //array to hold data from server
    var uuidArray = [String]()
    var picArray = [PFFileObject]()
       
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.alwaysBounceVertical = true
        //top title
        self.navigationItem.title = guestname.last
       

        countNumPics()
        loadPosts()
    
        
    }

    func countNumPics(){
        let query = PFQuery(className: "post")
        query.whereKey("username", equalTo: guestname.last!)
        
        query.countObjectsInBackground(block: { (count: Int32, error: Error?) in
           
            print("total count = \(count)")
            if error == nil {
                self.postCount = count
                self.collectionView.reloadData()
            }else {
                print(error?.localizedDescription)
            }
        })
     }
    
    //posts loading function
    func loadPosts() {
        
        print("loading.. guest ")
        let query = PFQuery(className: "post")
        query.whereKey("username", equalTo: guestname.last!)
        query.limit = page
        query.findObjectsInBackground { (objects:[PFObject]?, error:Error?) in
            
            if error == nil{
                
                //clean array
                self.picArray.removeAll(keepingCapacity: false)
                self.uuidArray.removeAll(keepingCapacity: false)
            
                for object in objects! {
                
                    //hold found info in arrays
                    self.uuidArray.append(object.value(forKey: "uuid") as! String)
                    self.picArray.append(object.value(forKey: "pic") as! PFFileObject)
                    //print("guest object: \(object.value(forKey: "uuid"))")
                }
                
                self.collectionView.reloadData()
                
            }else{
                print(error?.localizedDescription)
            }
            
        }
    }

    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //print("index path row: \(indexPath.row)")
        //print("pic array count: \(picArray.count)")
    
        if indexPath.row == self.picArray.count - 1 {

            print("load more... guest postcount = \(self.postCount)")
            //use pagination
            loadmore()
            
        }
    }
    func loadmore() {
        
        var curCount: Int = 0
        print("guest last username = \(guestname.last ?? "nil")")
        
        if page < postCount {
            
            curCount = page
            print("before:  page = \(page) ")
            page = (page+20 > self.postCount) ? Int(self.postCount) : (page+20)
            print("after:  page = \(page) ")
          
            //load more posts
            let query = PFQuery(className: "post")
            query.whereKey("username", equalTo: guestname.last!)
            query.skip = curCount
            query.limit = 20
            query.findObjectsInBackground { (objects:[PFObject]?, error:Error?) in
                
                if error == nil {
                    
                    //clean array
                    //self.picArray.removeAll(keepingCapacity: false)
                    //self.uuidArray.removeAll(keepingCapacity: false)
                    
                    for object in objects! {
                        self.uuidArray.append(object.value(forKey: "uuid") as! String)
                        self.picArray.append(object.value(forKey: "pic") as! PFFileObject)
                        print("append.. \(object.value(forKey: "uuid") as! String)")
                    }
                    
                    print("appending to picArray \(self.picArray.count)  objcount=\(objects?.count ?? 0)")
                        self.collectionView.reloadData()
                        
                    }else {
                        print(error?.localizedDescription)
                }
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
