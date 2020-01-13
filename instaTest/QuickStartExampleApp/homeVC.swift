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
        
        //always vertical scroll
        self.collectionView.alwaysBounceVertical = true
        
       //background color
        collectionView.backgroundColor = .white
        
        //title at the top
        self.navigationItem.title = PFUser.current()?.username?.uppercased()
        
        //pull to refresh
        let refresher = UIRefreshControl()
        let title = NSLocalizedString("PullToReresh", comment: "Pull to refresh")
        refresher.attributedTitle = NSAttributedString(string: title)
        refresher.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        collectionView.refreshControl = refresher
        
        //receive notification from editVC
        NotificationCenter.default.addObserver(self, selector: #selector(reload(sender:)), name: Notification.Name("reload"), object: nil)
        
        //load post
        loadPosts()
    }
    
    
    
    //refreshing func
    @objc func refresh(sender:AnyObject) {
        
        //reload data info
        collectionView.reloadData()
//        DispatchQueue.main.async{
//            print("start reloading data")
//            self.collectionView.reloadData()
//        }
        
        //stop refresher animating
        sender.endRefreshing()
    }
    
    @objc func reload(sender:Any) {
        collectionView.reloadData()
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
        
        //STEP 1: get user data
        //define header
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! headerView
        header.fullnameLbl.text = (PFUser.current()?.object(forKey: "fullname") as? String)?.uppercased()
        header.fullnameLbl.sizeToFit()
        
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
        
        //STEP 2: count statistics
        //count total posts
        let posts = PFQuery(className: "post")
        posts.whereKey("username", equalTo: PFUser.current()?.username!)
        posts.countObjectsInBackground { (count, error) in
            header.posts.text = "\(count)"
        }
        //count total followers
        let follower = PFQuery(className: "follow")
        follower.whereKey("following", equalTo: PFUser.current()?.username!)
        follower.countObjectsInBackground { (count, error) in
            header.followers.text = "\(count)"
        }
        
        //count total following
        let following = PFQuery(className: "follow")
        following.whereKey("follower", equalTo: PFUser.current()?.username!)
        following.countObjectsInBackground { (count, error) in
            header.followings.text = "\(count)"
        }

        //STEP 3: implement tap gestures
        //tap posts
        let postsTap = UITapGestureRecognizer(target: self, action: #selector(homeVC.postsTap))
        postsTap.numberOfTouchesRequired = 1
        header.posts.isUserInteractionEnabled = true
        header.posts.addGestureRecognizer(postsTap)
  
        //tap followers
        let followersTap = UITapGestureRecognizer(target: self, action: #selector(homeVC.followersTap))
        followersTap.numberOfTouchesRequired = 1
        header.followers.isUserInteractionEnabled = true
        header.followers.addGestureRecognizer(followersTap)
        
        //tap followings
        let followingsTap = UITapGestureRecognizer(target: self, action: #selector(homeVC.followingsTap))
        followingsTap.numberOfTouchesRequired = 1
        header.followings.isUserInteractionEnabled = true
        header.followings.addGestureRecognizer(followingsTap)
  
        return header
        
    }

    //taps posts label
    @objc func postsTap(){
        if !picArray.isEmpty {
            let index = NSIndexPath(item: 0, section: 0)
            self.collectionView.scrollToItem(at: index as IndexPath, at: UICollectionView.ScrollPosition.top, animated: true)
        }
        
    }

 
    @objc func followersTap(){
        user = PFUser.current()!.username!
        showItem = "followers"
      
        let followers = self.storyboard?.instantiateViewController(identifier: "followersVC") as! followersVC
          
        self.navigationController?.pushViewController(followers, animated: true)
        
    }
     
    @objc func followingsTap() {
        user = PFUser.current()!.username!
        showItem = "followings"
        
        let followings = self.storyboard?.instantiateViewController(identifier: "followersVC") as! followersVC
        self.navigationController?.pushViewController(followings, animated: true)
        
    }

    @IBAction func logout(_ sender: Any) {
        
        //remove user from default
        UserDefaults.standard.removeObject(forKey: "username")
        UserDefaults.standard.synchronize()
        
        let signin = self.storyboard?.instantiateViewController(identifier: "signInVC") as! signInVC
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = signin
        
    }
    
    
}
