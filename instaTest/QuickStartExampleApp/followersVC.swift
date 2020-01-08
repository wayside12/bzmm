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
    
    //cell config

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //define cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! followersCell
        
        //connect data from server to
        cell.usernameLbl.text = usernameArray[indexPath.row]
        avaArray[indexPath.row].getDataInBackground { (data, error) in
            if error == nil{
                cell.avaImg.image = UIImage(data: data!)
            }else{
                print(error?.localizedDescription)
            }
        }
        return cell
    }
    
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
