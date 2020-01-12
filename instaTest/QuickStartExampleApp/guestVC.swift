//
//  guestVC.swift
//  QuickStartExampleApp
//
//  Created by Bo Zhang on 1/8/20.
//  Copyright © 2020 Back4App. All rights reserved.
//

import UIKit
import Parse
var guestname = [String]()

class guestVC: UICollectionViewController {

    //UI objects
    var refresher = UIRefreshControl()
    var page : Int = 10
    
    //array to hold data from server
    var uuidArray = [String]()
    var picArray = [PFFileObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //allow vertical control
        self.collectionView.alwaysBounceVertical = true
        
        //top title
        self.navigationItem.title = guestname.last
        
        //new back button (declare our custom back button instead)
        self.navigationItem.hidesBackButton = true
        let backBtn = UIBarButtonItem(title: "back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(back(sender:)))
        self.navigationItem.leftBarButtonItem = backBtn
        
        //swipe to go back
        let backSwipe = UISwipeGestureRecognizer(target: self, action: #selector(back(sender:)))
        backSwipe.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(backSwipe)

        //pull to refresh
        let refresher = UIRefreshControl()
        let title = NSLocalizedString("PullToRefresh", comment: "Pull to refresh")
        refresher.attributedTitle = NSAttributedString(string: title)
        refresher.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        collectionView.refreshControl = refresher
        
        //load posts
        loadPosts()
        
    }

    @objc func refresh(sender:AnyObject){
        collectionView.reloadData()
        refresher.endRefreshing()  //guest view stuck refreshing
        
    }

    //back function
    @objc func back(sender:UIBarButtonItem){
        
        //push back
        self.navigationController?.popViewController(animated: true)
        
        //deduct last username from guestname
        if !guestname.isEmpty{
            guestname.removeLast()
        }
    }
    
    //posts loading function
    func loadPosts() {
        
        let query = PFQuery(className: "post")
        query.whereKey("username", equalTo: guestname.last)
        query.limit = 10
        query.findObjectsInBackground { (objects:[PFObject]?, error:Error?) in
            
            if error == nil{
                for object in objects! {
                
                    //hold found info in arrays
                    self.uuidArray.append(object.value(forKey: "uuid") as! String)
                    self.picArray.append(object.value(forKey: "pic") as! PFFileObject)
                }
                self.collectionView.reloadData()
                
            }else{
                print(error?.localizedDescription)
            }
            
        }
    }
    
    //number of cells
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picArray.count
    }
    
    //data for each cell
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
    
    //header config
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        //define header
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as! headerView
        
        //STEP 1: load data to guest
        let infoQuery = PFQuery(className: "_User")
        infoQuery.whereKey("username", equalTo: guestname.last)
        infoQuery.findObjectsInBackground { (objects:[PFObject]?, error:Error?) in
            if error == nil{
                
                //wrong user
                if objects!.isEmpty{
                    print("wrong user")
                }
                for object in objects! {
                    header.fullnameLbl.text = (object.object(forKey: "fullname") as! String).uppercased()
                    header.fullnameLbl.sizeToFit()
                    header.bioLbl.text = object.object(forKey: "bio") as! String
                    header.bioLbl.sizeToFit()
                    header.webTxt.text = object.object(forKey: "web") as! String
                    header.webTxt.sizeToFit()
                    
                    let avaFile = object.object(forKey: "ava") as! PFFileObject
                    avaFile.getDataInBackground { (data:Data?, error:Error?) in
                        if error == nil{
                            header.avaImg.image = UIImage(data: data!)
                        }else{
                            print(error?.localizedDescription)
                        }
                    }
                
                    
                }
                
            }else {
                print(error?.localizedDescription)
            }
        }
        
         //show do current user follow the guest
        let searchQuery = PFQuery(className: "follow")
        searchQuery.whereKey("follower", equalTo: PFUser.current()?.username)
        searchQuery.whereKey("following", equalTo: guestname.last)
        searchQuery.countObjectsInBackground { (count, error) in
            if error == nil{
                if count == 0{
                    header.button.setTitle("FOLLOW", for: UIControl.State.normal)
                    header.button.backgroundColor = .lightGray
                }else{
                    //is following
                    header.button.setTitle("FOLLOWING", for: UIControl.State.normal)
                    header.button.backgroundColor = .green
                }
            }else {
                print(error?.localizedDescription)
            }
            
        }
        
        //STEP 3: count the statistics
        //count posts
        let postQuery = PFQuery(className: "post")
        postQuery.whereKey("username", equalTo: guestname.last)
        postQuery.countObjectsInBackground { (count, error) in
            if error == nil{
                header.posts.text = "\(count)"
            }else{
                print(error?.localizedDescription)
            }
        }
        
        //count followers
        let followerQuery = PFQuery(className: "follow")
        followerQuery.whereKey("following", equalTo: guestname.last)
        followerQuery.countObjectsInBackground { (count, error) in
            if error == nil{
                header.followers.text = "\(count)"
            }else{
                print(error?.localizedDescription)
            }
        }
        
        //count followings
        let followingQuery = PFQuery(className: "follow")
        followingQuery.whereKey("follower", equalTo: guestname.last)
        followingQuery.countObjectsInBackground { (count, error) in
            if error == nil{
                 header.followings.text = "\(count)"
             }else{
                 print(error?.localizedDescription)
             }
        }
        
        //STEP 4: implement tap gestures
        //tap to post label
        let postTap = UITapGestureRecognizer(target: self, action: #selector(guestVC.postTap))
        postTap.numberOfTapsRequired = 1
        header.posts.isUserInteractionEnabled = true
        header.posts.addGestureRecognizer(postTap)
        
        //tap to follower label
        let followerTap = UITapGestureRecognizer(target: self, action: #selector(guestVC.followerTap))
        followerTap.numberOfTapsRequired = 1
        header.followers.isUserInteractionEnabled = true
        header.followers.addGestureRecognizer(followerTap)
        
        //tap to following label
        let followingTap = UITapGestureRecognizer(target: self, action: #selector(guestVC.followingTap))
        followerTap.numberOfTapsRequired = 1
        header.followings.isUserInteractionEnabled = true
        header.addGestureRecognizer(followingTap)
        
        return header
    }
    
    //tapped posts label
    @objc func postTap(){
        if !picArray.isEmpty{
            let index = NSIndexPath(item: 0, section: 0)
            self.collectionView.scrollToItem(at: index as IndexPath, at: UICollectionView.ScrollPosition.top, animated: true)
        }
        
        
    }
    
    //tapped follower label
    @objc func followerTap(){
        user = guestname.last!
        showItem = "followers"
        
        //define followersVC
        let followers = self.storyboard?.instantiateViewController(identifier: "followersVC") as! followersVC
        
        //navigate to it
        self.navigationController?.pushViewController(followers, animated: true)
    }
    
    //tapped following label
    @objc func followingTap(){
        user = guestname.last!
        showItem = "followings"
        
        //define followerVC
        let followings = self.storyboard?.instantiateViewController(identifier: "followersVC") as! followersVC
        
        //navigate to it
        self.navigationController?.pushViewController(followings, animated: true)
        
    }

    
}

