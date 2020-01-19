//
//  FollowersVC.swift
//  QuickStartExampleApp
//
//  Created by Bo Zhang on 1/7/20.
//  Copyright © 2020 Back4App. All rights reserved.
//

import UIKit
import Parse

var showItem = String()
var user = String()

class followersVC: UITableViewController {

    //arrays to hold data from servers
    var usernameArray = [String]()
    var avaArray = [PFFileObject]()
    
    //array showing who we follow or who follows us
    var followArray = [String]()
    
  
    
    //default function
    override func viewDidLoad() {
        super.viewDidLoad()

        //show title
        //self.navigationController?.title = showItem.uppercased()
        DispatchQueue.main.async {
              self.title = showItem
          }
        
        print("showItem: \(showItem)")
        if showItem == "followers" {
            self.loadFollowers()
        }
        if showItem == "followings" {
            self.loadFollowings()
        }
        
    }

    //load followers
    func loadFollowers(){
        
        //STEP 1
        //find followers of user
        let followQuery = PFQuery(className: "follow")
        followQuery.whereKey("following", equalTo: user)
        followQuery.findObjectsInBackground { (objects:[PFObject]?, error:Error?) in
           
            if error == nil {
                
                //clean up
                self.followArray.removeAll(keepingCapacity: false)
                
                for object in objects! {
                    self.followArray.append(object.value(forKey: "follower") as! String)
                }
                
                //STEP 2: find all users following the user
                let query = PFUser.query()
                query?.whereKey("username", containedIn: self.followArray)
                query?.addDescendingOrder("CreatedAt")
                query?.findObjectsInBackground { (objects:[PFObject]?, error:Error?) in
                    
                    if error == nil {
                        //clean up
                        self.usernameArray.removeAll(keepingCapacity: false)
                        self.avaArray.removeAll(keepingCapacity: false)
                        
                        //STEP 3: find related objects in User class in Parse
                        for object in objects! {
                            self.usernameArray.append(object.object(forKey: "username") as! String)
                            self.avaArray.append(object.object(forKey: "ava") as! PFFileObject)
                            self.tableView.reloadData()
                        }
                    } else {
                        print(error?.localizedDescription)
                    }
                    
                }
                
            }else {
                print(error?.localizedDescription)
            }
        }
    }
    
    
    func loadFollowings(){
        
        //find user following
        let followQuery = PFQuery(className: "follow")
        followQuery.whereKey("follower", equalTo: user)
        followQuery.findObjectsInBackground { (objects:[PFObject]?, error:Error?) in
            
            if error == nil {
            
                //clean up
                self.followArray.removeAll(keepingCapacity: false)
                for object in objects! {
                    
                    self.followArray.append(object.value(forKey: "following") as! String)
                }
                
                //find all users this user follows
                let query = PFUser.query()
                query?.whereKey("username", containedIn: self.followArray)
                query?.addDescendingOrder("CreatedAt")
                query?.findObjectsInBackground(block: { (objects:[PFObject]!, error:Error?) in
                    
                    if error == nil{
                        //clean up
                        self.usernameArray.removeAll(keepingCapacity: false)
                        self.avaArray.removeAll(keepingCapacity: false)
                        
                        for object in objects! {
                            self.usernameArray.append(object.object(forKey: "username") as! String)
                            self.avaArray.append(object.object(forKey: "ava") as! PFFileObject)
                            self.tableView.reloadData()
                        }
                        
                        
                    }else{
                        print(error?.localizedDescription)
                    }
                })
                
            } else {
                print(error?.localizedDescription)
            }
            
        }
        
    }
    //cell number
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return usernameArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.size.width/4
        
    }
    
    //cell config

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //define cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! followersCell
        
        
        //STEP1: connect data from server to
        cell.usernameLbl.text = usernameArray[indexPath.row]
        avaArray[indexPath.row].getDataInBackground { (data, error) in
            if error == nil{
                cell.avaImg.image = UIImage(data: data!)
            }else{
                print(error?.localizedDescription)
            }
        }
        //STEP 2
        //in case of "followers", show if current user follows or not
        let query = PFQuery(className: "follow")
        query.whereKey("follower", equalTo: PFUser.current()?.username!)
        query.whereKey("following", equalTo: cell.usernameLbl.text!)
        query.countObjectsInBackground(block: { (count:Int32, error:Error?) in
            if error == nil{
                
                //print("username: \(cell.usernameLbl.text!), count = \(count)")
                if count == 0{
                    cell.followBtn.setTitle("Follow", for: UIControl.State.normal)
                    cell.followBtn.backgroundColor = .lightGray
                }else {
                    cell.followBtn.setTitle("Following", for: UIControl.State.normal)
                    cell.followBtn.backgroundColor = UIColor.green
                }
                
            }else{
                print(error?.localizedDescription)
            }
            
        })
        
        //hide follow button if cell user is current user
        //do not understand what this does ??
        if cell.usernameLbl.text == PFUser.current()?.username {
            cell.followBtn.isHidden = true
        }
    
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! followersCell
        
        if cell.usernameLbl.text == PFUser.current()?.username {
            
            let home = self.storyboard?.instantiateViewController(identifier: "homeVC") as! homeVC
            self.navigationController?.pushViewController(home, animated: true)
                        
        }else {
            guestname.append(cell.usernameLbl.text!)
            let guest = self.storyboard?.instantiateViewController(identifier: "guestVC2") as! guestVC2
            self.navigationController?.pushViewController(guest, animated: true)
            
        }
    }
    
  

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

  

  

}
