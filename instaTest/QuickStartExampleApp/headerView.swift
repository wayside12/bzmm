//
//  headerView.swift
//  QuickStartExampleApp
//
//  Created by Bo Zhang on 1/6/20.
//  Copyright © 2020 Back4App. All rights reserved.
//

import UIKit
import Parse
class headerView: UICollectionReusableView {
    
    @IBOutlet var avaImg: UIImageView!
    @IBOutlet var fullnameLbl: UILabel!
    @IBOutlet var webTxt: UITextView!
    @IBOutlet var bioLbl: UILabel!
    
    @IBOutlet var posts: UILabel!
    @IBOutlet var followers: UILabel!
    @IBOutlet var followings: UILabel!
    
    @IBOutlet var postTitle: UILabel!
    @IBOutlet var followersTitle: UILabel!
    @IBOutlet var followingsTitle: UILabel!
 
    @IBOutlet var button: UIButton!
    
    
    //default function
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //alignment
        let width = UIScreen.main.bounds.width
        
        
        avaImg.frame = CGRect(x: width/16, y: width/16, width: width/4, height: width/4)

        posts.frame = CGRect(x: width/2.5, y: avaImg.frame.origin.y, width: 50, height: 30)
        followers.frame = CGRect(x: width/1.7, y: avaImg.frame.origin.y, width: 50, height: 30)
        followings.frame = CGRect(x: width/1.25, y: avaImg.frame.origin.y, width: 50, height: 30)
        
        postTitle.center = CGPoint(x: posts.center.x, y: posts.center.y + 20)
        followersTitle.center = CGPoint(x: followers.center.x, y: followers.center.y + 20)
        followingsTitle.center = CGPoint(x: followings.center.x, y: followings.center.y + 20)
        
        button.frame = CGRect(x: width/2.5, y: postTitle.center.y + 20, width: width - postTitle.frame.origin.x - 10, height: 30)
        
        fullnameLbl.frame = CGRect(x: avaImg.frame.origin.x, y: avaImg.frame.origin.y + avaImg.frame.size.height + 10, width: width - 30, height: 30)
        webTxt.frame = CGRect(x: avaImg.frame.origin.x - 5, y: fullnameLbl.frame.origin.y + 15, width: width - 30, height: 20)
        bioLbl.frame = CGRect(x: avaImg.frame.origin.x, y: webTxt.frame.origin.y + 30, width: width - 30, height: 30)
        
        print("screen width = \(width)")
        print("button width = \(button.frame.size.width)")
        print("button x = \(button.frame.origin.x)")
        
        print("ava image x \(avaImg.frame.origin.x)  y = \(avaImg.frame.origin.y)  width = \(avaImg.frame.size.width) height = \(avaImg.frame.size.height)")
        
        print("fullname label x = \(fullnameLbl.frame.origin.x)  y = \(fullnameLbl.frame.origin.y)  height = \(fullnameLbl.frame.size.height)")
        //round img
        avaImg.layer.cornerRadius = avaImg.frame.size.width/2
        avaImg.clipsToBounds = true
        
    }
    
    
    
    
    
    
    @IBAction func followBtn_clicked(_ sender: Any) {
    
    //follow/unfollow
     let title = button.title(for: UIControl.State.normal)
     if title?.uppercased() == "FOLLOW" {
         let object = PFObject(className: "follow")
         object["follower"] = PFUser.current()?.username
        object["following"] = guestname.last
         
         object.saveInBackground { (success, error) in
             if error == nil{
                 self.button.setTitle("FOLLOWING", for: UIControl.State.normal)
                 self.button.backgroundColor = .green
                 
             }else{
                 print(error?.localizedDescription)
             }
         }
     }else {
         let query = PFQuery(className: "follow")
         query.whereKey("follower", equalTo: PFUser.current()?.username)
        query.whereKey("following", equalTo: guestname.last)
         query.findObjectsInBackground { (objects:[PFObject]?, error:Error?) in
             if error == nil{
                 for object in objects! {
                     object.deleteInBackground { (success, error) in
                         if error == nil{
                             //successfully remove following relationship
                             self.button.setTitle("FOLLOW", for: UIControl.State.normal)
                             self.button.backgroundColor = .lightGray
                             
                             
                         }else{
                             print(error?.localizedDescription)
                         }
                     }
                 }
                 
             }else{
                 print(error?.localizedDescription)
             }
         }
         
     }
    
    }
    
}
